//
//  NewsFeedViewModel.swift
//  NewsFactory
//
//  Created by Josip Marković on 31/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Realm


class NewsFeedViewModel: ViewModelType{
    
    
    struct Input {
        let toggleExpandSubject: PublishSubject<UIButton>
        let fetchNewsSubject: PublishSubject<DataFetchEnum>
        let getNewsDataSubject: PublishSubject<DataFetchEnum>
        var favoriteEdit: ((News) -> Void)
        let favoriteClickSubject: PublishSubject<String>
        let detailsDelegateSubject: PublishSubject<IndexPath>
        var manageFavoritesSubject: PublishSubject<News>
    }
    
    struct Output {
        var allNews: [ExpandableNews]
        var refreshAndLoaderSubject: ReplaySubject<Bool>
        let sectionExpandSubject: PublishSubject<SectionExpandEnum>
        let toastSubject: PublishSubject<String>
        let alertPopUpSubject: PublishSubject<AlertSubjectEnum>
        let tableViewControlSubject: PublishSubject<NewsFeedTableViewSubjectEnum>

    }
    
    struct Dependencies {
        let standardUserDefaults: UserDefaults
        let database: RealmManager
        let dataRepository: DataRepositoryProtocol
        let subscribeScheduler: SchedulerType
    }
    
    var bbcSelected: Bool = true
    var detailsDelegate: DetailsDelegate?
    var favoriteClickDelegate: FavoriteClickDelegate?
    private let dependencies: Dependencies
    public var input: Input?
    public var output: Output?
    var favoritesDelegate: FavoritesDelegate?
    var disposables: [Disposable] = []
    

    init (dependencies: Dependencies){
        self.dependencies = dependencies
        favoriteClickDelegate = self
    }
    
    func transform(input: Input) -> Output {
        
        disposables.append(collectAndPrepareData(for: input.getNewsDataSubject))
        disposables.append(manageFavorites(subject: input.manageFavoritesSubject))
        disposables.append(openNewsDetails(subject: input.detailsDelegateSubject))
        disposables.append(favoriteClicked(subject: input.favoriteClickSubject))
        
        
        let output = Output(allNews: [], refreshAndLoaderSubject: ReplaySubject.create(bufferSize: 1), sectionExpandSubject: PublishSubject(), toastSubject: PublishSubject(), alertPopUpSubject: PublishSubject(), tableViewControlSubject: PublishSubject())
        self.output = output
        self.input = input
        return output
    }
    
    func getDataToShow(){
        let lastKnownTime = dependencies.standardUserDefaults.integer(forKey: "Current time")
        if Int(Date().timeIntervalSince1970)-lastKnownTime>300 ||  output?.allNews.isEmpty ?? true{
            input?.getNewsDataSubject.onNext(.getNews)
        }
    }
    
    func saveCurrentTime(){
        let currentTime = Date().timeIntervalSince1970
        dependencies.standardUserDefaults.set(currentTime, forKey: "Current time")
    }
    
    func toggleExpand(button: UIButton){
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in output?.allNews[section].news.indices ?? Range(1...2){
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = output?.allNews[section].isExpanded
        output?.allNews[section].isExpanded = !(isExpanded ?? false)
        
        if isExpanded ?? false{
            output?.sectionExpandSubject.onNext(.sectionCollapse(indexPaths))
        }else{
            output?.sectionExpandSubject.onNext(.sectionExpand(indexPaths))
        }
    }
    
    func collectAndPrepareData(for subject: PublishSubject<DataFetchEnum>) -> Disposable{
        return subject.flatMap({[unowned self] (enumCase) -> Observable<([News], [News], [RealmNews])> in
            switch enumCase{
            case .getNews:
                self.output?.refreshAndLoaderSubject.onNext(true)
            case .refreshNews:
                break
            }
            let observable = Observable.zip(self.dependencies.dataRepository.getBBCNews(), self.dependencies.dataRepository.getIGNNews(), self.dependencies.database.getObjects()) { (bbcNews, ignNews, favNews) in
                return(bbcNews, ignNews, favNews)
            }
            return observable
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.subscribeScheduler)
            .map({[unowned self] (bbcNews, ignNews, realmNews) -> (ExpandableNews,ExpandableNews) in
                self.output?.allNews.removeAll()
                let bbcNewsFeedArray = self.createScreenData(news: bbcNews, realmNews: realmNews, title: "BBC News")
                let ignNewsFeedArray = self.createScreenData(news: ignNews, realmNews: realmNews, title: "IGN News")
                return (bbcNewsFeedArray, ignNewsFeedArray)
            }).subscribe(onNext: { [unowned self] (bbcNews, ignNews) in
                self.output?.allNews.append(bbcNews)
                self.output?.allNews.append(ignNews)
                self.output?.tableViewControlSubject.onNext(.reloadTable)
                self.output?.refreshAndLoaderSubject.onNext(false)
                self.saveCurrentTime()
                }, onError: { [unowned self] error in
                    self.output?.alertPopUpSubject.onNext(.alamofireAlert)
                    self.output?.refreshAndLoaderSubject.onNext(false)
            })
    }
    
    func createScreenData(news: [News], realmNews: [RealmNews], title: String) -> ExpandableNews{
        for favoriteNews in realmNews{
            if let indexOfMainNews = news.enumerated().first(where: { (data) -> Bool in
                data.element.title == favoriteNews.realmTitle
            }){
                news[indexOfMainNews.offset].isFavorite = true
            }
        }
        let expandableNews = ExpandableNews(title: title, isExpanded: true, news: news)
        return expandableNews
    }
    
    func manageFavorites(subject: PublishSubject<News>) -> Disposable{
        
        return subject.flatMap({ [unowned self] (news) -> Observable<String> in
            if news.isFavorite{
                news.isFavorite = false
                if let newsEnumerated = self.output?.allNews[0].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title}){
                    self.reloadRowAt(row: newsEnumerated.offset, section: 0, state: false)}
                if let newsEnumerated = self.output?.allNews[1].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title})
                {
                    self.reloadRowAt(row: newsEnumerated.offset, section: 1, state: false)}
                return self.dependencies.database.deleteObject(news: news)
            }else{
                if let newsEnumerated = self.output?.allNews[0].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title})
                {
                    self.reloadRowAt(row: newsEnumerated.offset, section: 0, state: true)}
                if let newsEnumerated = self.output?.allNews[1].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title})
                {
                    self.reloadRowAt(row: newsEnumerated.offset, section: 1, state: true)}
                return self.dependencies.database.saveObject(news: news)
            }
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.subscribeScheduler)
            .subscribe(onNext: {[unowned self] (string) in
                self.output?.toastSubject.onNext(string)
                print(string)
                },onError: {[unowned self](error) in
                    print(error)
                    self.output?.alertPopUpSubject.onNext(.realmAlert)
            })
    }
    
    func reloadRowAt(row: Int, section: Int, state: Bool){
        let indexPath: IndexPath = IndexPath(row: row, section: section)
        self.output?.allNews[section].news[row].isFavorite = state
        self.output?.tableViewControlSubject.onNext(.reloadRows([indexPath]))
    }
    
    
    func openNewsDetails(subject: PublishSubject<IndexPath>) -> Disposable{
        return subject.map({[unowned self] (indexPath) -> News in
            let newsToShow = self.output?.allNews[indexPath.section].news[indexPath.row]
            return newsToShow!
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.subscribeScheduler)
            .subscribe(onNext: {[unowned self] (news) in
                guard let delegate = self.favoritesDelegate else { return }
                guard let delegateDetails = self.detailsDelegate else { return }
                delegateDetails.showDetailedNews(news: news, delegate: delegate)
            })
    }
    
    func favoriteClicked(subject: PublishSubject<String>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(dependencies.subscribeScheduler).subscribe(onNext: {[unowned self] (newsTitle) in
            self.favoriteClickDelegate?.favoriteClicked(newsTitle: newsTitle)
        })
    }
}

extension NewsFeedViewModel: FavoriteClickDelegate{
    
    func favoriteClicked(newsTitle: String) {
        if let indexOfMainNews = self.output?.allNews[0].news.enumerated().first(where: { (data) -> Bool in
            data.element.title == newsTitle
        }) {
            input?.favoriteEdit((self.output?.allNews[0].news[indexOfMainNews.offset])!)
        }
        if let indexOfMainNews = self.output?.allNews[1].news.enumerated().first(where: { (data) -> Bool in
            data.element.title == newsTitle
        }) {
            input?.favoriteEdit((self.output?.allNews[1].news[indexOfMainNews.offset])!)
        }
    }
}
