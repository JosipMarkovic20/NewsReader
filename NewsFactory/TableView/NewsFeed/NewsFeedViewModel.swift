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


class NewsFeedViewModel: NewsFeedViewModelProtocol{
    
    
 
    
    var allNews = [ExpandableNews]()
    let standardUserDefaults = UserDefaults.standard
    let database = RealmManager()
    var refreshAndLoaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var bbcSelected: Bool = true
    let sectionExpandSubject = PublishSubject<SectionExpandEnum>()
    let toastSubject = PublishSubject<String>()
    var toggleExpandSubject = PublishSubject<UIButton>()
    var manageFavoritesSubject = PublishSubject<News>()
    let alertPopUpSubject = PublishSubject<AlertSubjectEnum>()
    let tableViewControlSubject = PublishSubject<NewsFeedTableViewSubjectEnum>()
    var fetchNewsSubject = PublishSubject<DataFetchEnum>()
    var getNewsDataSubject = PublishSubject<DataFetchEnum>()
    var dataRepository: DataRepositoryProtocol
    var subscribeScheduler: SchedulerType
    var detailsDelegateSubject = PublishSubject<IndexPath>()
    var detailsDelegate: DetailsDelegate?
    var favoriteEdit: ((News) -> Void)?
    var favoriteClickSubject = PublishSubject<String>()
    var favoriteClickDelegate: FavoriteClickDelegate?
    
    
    
    
    init (dataRepository: DataRepositoryProtocol, subscribeScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)){
        self.dataRepository = dataRepository
        self.subscribeScheduler = subscribeScheduler
        favoriteClickDelegate = self
    }
    
    
    func getDataToShow(){
        let lastKnownTime = standardUserDefaults.integer(forKey: "Current time")
        if Int(Date().timeIntervalSince1970)-lastKnownTime>300 || self.allNews.isEmpty{
            getNewsDataSubject.onNext(.getNews)
        }
    }
    
    func saveCurrentTime(){
        let currentTime = Date().timeIntervalSince1970
        standardUserDefaults.set(currentTime, forKey: "Current time")
    }
    
    func toggleExpand(button: UIButton){
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in allNews[section].news.indices{
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = allNews[section].isExpanded
        allNews[section].isExpanded = !isExpanded
        
        if isExpanded{
            sectionExpandSubject.onNext(.sectionCollapse(indexPaths))
        }else{
            sectionExpandSubject.onNext(.sectionExpand(indexPaths))
        }
    }
    
    func collectAndPrepareData(for subject: PublishSubject<DataFetchEnum>) -> Disposable{
        return subject.flatMap({[unowned self] (enumCase) -> Observable<([News], [News], [RealmNews])> in
            switch enumCase{
            case .getNews:
                self.refreshAndLoaderSubject.onNext(true)
            case .refreshNews:
                break
            }
            let observable = Observable.zip(self.dataRepository.getBBCNews(), self.dataRepository.getIGNNews(), self.database.getObjects()) { (bbcNews, ignNews, favNews) in
                return(bbcNews, ignNews, favNews)
            }
            return observable
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(subscribeScheduler)
            .map({[unowned self] (bbcNews, ignNews, realmNews) -> (ExpandableNews,ExpandableNews) in
                self.allNews.removeAll()
                let bbcNewsFeedArray = self.createScreenData(news: bbcNews, realmNews: realmNews, title: "BBC News")
                let ignNewsFeedArray = self.createScreenData(news: ignNews, realmNews: realmNews, title: "IGN News")
                return (bbcNewsFeedArray, ignNewsFeedArray)
            }).subscribe(onNext: { [unowned self] (bbcNews, ignNews) in
                self.allNews.append(bbcNews)
                self.allNews.append(ignNews)
                self.tableViewControlSubject.onNext(.reloadTable)
                self.refreshAndLoaderSubject.onNext(false)
                self.saveCurrentTime()
                }, onError: { [unowned self] error in
                    self.alertPopUpSubject.onNext(.alamofireAlert)
                    self.refreshAndLoaderSubject.onNext(false)
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
                if let newsEnumerated = self.allNews[0].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title}){
                    self.reloadRowAt(row: newsEnumerated.offset, section: 0, state: false)}
                if let newsEnumerated = self.allNews[1].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title})
                {
                    self.reloadRowAt(row: newsEnumerated.offset, section: 1, state: false)}
                return self.database.deleteObject(news: news)
            }else{
                if let newsEnumerated = self.allNews[0].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title})
                {
                    self.reloadRowAt(row: newsEnumerated.offset, section: 0, state: true)}
                if let newsEnumerated = self.allNews[1].news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title})
                {
                    self.reloadRowAt(row: newsEnumerated.offset, section: 1, state: true)}
                return self.database.saveObject(news: news)
            }
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(subscribeScheduler)
            .subscribe(onNext: {[unowned self] (string) in
                self.toastSubject.onNext(string)
                print(string)
                },onError: {[unowned self](error) in
                    print(error)
                    self.alertPopUpSubject.onNext(.realmAlert)
            })
    }
    
    func reloadRowAt(row: Int, section: Int, state: Bool){
        let indexPath: IndexPath = IndexPath(row: row, section: section)
        self.allNews[section].news[row].isFavorite = state
        self.tableViewControlSubject.onNext(.reloadRows([indexPath]))
    }
    
    
    func openNewsDetails(subject: PublishSubject<IndexPath>, favoritesDelegate: FavoritesDelegate) -> Disposable{
        return subject.map({[unowned self] (indexPath) -> News in
            let newsToShow = self.allNews[indexPath.section].news[indexPath.row]
            return newsToShow
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(subscribeScheduler)
            .subscribe(onNext: {[unowned self] (news) in
                let delegate = favoritesDelegate
                guard let delegateDetails = self.detailsDelegate else { return }
                delegateDetails.showDetailedNews(news: news, delegate: delegate)
            })
    }
    
    func favoriteClicked(subject: PublishSubject<String>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(subscribeScheduler).subscribe(onNext: {[unowned self] (newsTitle) in
            self.favoriteClickDelegate?.favoriteClicked(newsTitle: newsTitle)
        })
    }
}


protocol NewsFeedViewModelProtocol {
    var allNews: [ExpandableNews] {get set}
    var fetchNewsSubject: PublishSubject<DataFetchEnum>  {get set}
    var getNewsDataSubject: PublishSubject<DataFetchEnum>  {get set}
    var toggleExpandSubject: PublishSubject<UIButton>  {get set}
    var refreshAndLoaderSubject: ReplaySubject<Bool> {get set}
    var manageFavoritesSubject: PublishSubject<News> {get set}
    var detailsDelegateSubject: PublishSubject<IndexPath> {get set}
    var detailsDelegate: DetailsDelegate? {get set}
    var favoriteEdit: ((News) -> Void)? {get set}
    var favoriteClickSubject: PublishSubject<String> {get set}
    var favoriteClickDelegate: FavoriteClickDelegate? {get set}
    
    func collectAndPrepareData(for subject: PublishSubject<DataFetchEnum>) -> Disposable
    func openNewsDetails(subject: PublishSubject<IndexPath>, favoritesDelegate: FavoritesDelegate) -> Disposable
    func favoriteClicked(subject: PublishSubject<String>) -> Disposable
}



extension NewsFeedViewModel: FavoriteClickDelegate{
    
    func favoriteClicked(newsTitle: String) {
        if let indexOfMainNews = self.allNews[0].news.enumerated().first(where: { (data) -> Bool in
            data.element.title == newsTitle
        }) {
            favoriteEdit?(self.allNews[0].news[indexOfMainNews.offset])
        }
        if let indexOfMainNews = self.allNews[1].news.enumerated().first(where: { (data) -> Bool in
            data.element.title == newsTitle
        }) {
            favoriteEdit?(self.allNews[1].news[indexOfMainNews.offset])
        }
    }
}
