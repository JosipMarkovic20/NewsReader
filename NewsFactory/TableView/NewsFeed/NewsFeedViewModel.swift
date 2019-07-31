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


class NewsFeedViewModel{
    
    let bbcNewsUrl: String =  "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=26a4db9c8a6c41dea9caa401fb634267"
    let ignNewsUrl: String = "https://newsapi.org/v1/articles?source=ign&sortBy=top&apiKey=26a4db9c8a6c41dea9caa401fb634267"
    var allNews = [ExpandableNews]()
    let alamofire = AlamofireManager()
    let standardUserDefaults = UserDefaults.standard
    let database = RealmManager()
    let tableReloadSubject = PublishSubject<Bool>()
    let getNewsSubject = PublishSubject<Bool>()
    let refreshAndLoaderSubject = PublishSubject<Bool>()
    let alertSubject = PublishSubject<Bool>()
    var bbcSelected: Bool = true
    let sectionExpandSubject = PublishSubject<SectionExpandEnum>()
    let favoritesControlSubject = PublishSubject<IndexPath>()
    let toastSubject = PublishSubject<String>()
    let realmAlertSubject = PublishSubject<Bool>()
    let handleExpandSubject = PublishSubject<UIButton>()
    let newsRefreshSubject = PublishSubject<Bool>()
    let removeFavoritesSubject = PublishSubject<News>()
    let addFavoriteSubject = PublishSubject<News>()
    let getInitalDataSubject = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    
    
    func getDataToShow(){
        let lastKnownTime = standardUserDefaults.integer(forKey: "Current time")
        if Int(Date().timeIntervalSince1970)-lastKnownTime>300 || self.allNews.isEmpty{
            refreshAndLoaderSubject.onNext(true)
            getNewsSubjectFunction()
        }
    }
    
    func saveCurrentTime(){
        let currentTime = Date().timeIntervalSince1970
        standardUserDefaults.set(currentTime, forKey: "Current time")
    }
    
    func handleExpanding(button: UIButton){
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in allNews[section].news.indices{
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = allNews[section].isExpanded
        allNews[section].isExpanded = !isExpanded
        
        if isExpanded{
            sectionExpandSubject.onNext(.SectionCollapse(indexPaths))
        }else{
            sectionExpandSubject.onNext(.SectionExpand(indexPaths))
        }
    }
    
    @objc func getNewsSubjectFunction(){
        getNewsSubject.onNext(true)
    }
    
    func collectAndPrepareData(for subject: PublishSubject<Bool>) -> Disposable{
        return subject.flatMap({[unowned self] (bool) -> Observable<([News], [News], [RealmNews])> in
            let observable = Observable.zip(self.alamofire.getNewsAlamofireWay(jsonUrlString: self.bbcNewsUrl), self.alamofire.getNewsAlamofireWay(jsonUrlString: self.ignNewsUrl), self.database.getObjects()) { (bbcNews, ignNews, favNews) in
                return(bbcNews, ignNews, favNews)
            }
            return observable
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (bbcNews, ignNews, realmNews) -> Void in
                let bbcNewsFeedArray = self.createScreenData(news: bbcNews, realmNews: realmNews, title: "BBC News")
                let ignNewsFeedArray = self.createScreenData(news: ignNews, realmNews: realmNews, title: "IGN News")
                self.allNews.append(bbcNewsFeedArray)
                self.allNews.append(ignNewsFeedArray)
            }).subscribe(onNext: { [unowned self] (allNewsFeed) in
                self.tableReloadSubject.onNext(true)
                self.refreshAndLoaderSubject.onNext(false)
                self.saveCurrentTime()
                }, onError: { [unowned self] error in
                    self.alertSubject.onNext(true)
                    self.refreshAndLoaderSubject.onNext(false)
            })
    }
    
    func createScreenData(news: [News], realmNews: [RealmNews], title: String) -> ExpandableNews{
        for favoriteNews in realmNews{
            if let indexOfMainNews = news.firstIndex(where: {$0.title==favoriteNews.realmTitle}){
                news[indexOfMainNews].isFavorite = true
            }
        }
        let expandableNews = ExpandableNews(title: title, isExpanded: true, news: news)
        return expandableNews
    }
    
    func removeFavorites(subject: PublishSubject<News>) -> Disposable {
        
        return subject.flatMap({ [unowned self] (news) -> Observable<String> in
            if let newsEnumerated = self.allNews[0].news.enumerated().first(where: { (data) -> Bool in
                data.element.title == news.title
            }){
                let indexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.allNews[0].news[newsEnumerated.offset].isFavorite = false
                self.favoritesControlSubject.onNext(indexPath)
            }
            if let newsEnumerated = self.allNews[1].news.enumerated().first(where: { (data) -> Bool in
                data.element.title == news.title
            }){
                let indexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.allNews[1].news[newsEnumerated.offset].isFavorite = false
                self.favoritesControlSubject.onNext(indexPath)
            }
            return self.database.deleteObject(news: news)
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (string) in
                self.toastSubject.onNext("Favorite Removed")
                print(string)
                },onError: {[unowned self](error) in
                    print(error)
                    self.realmAlertSubject.onNext(true)
            })
    }
    
    func addFavorites(subject: PublishSubject<News>) -> Disposable {
        return subject.flatMap({ [unowned self] (news) -> Observable<String> in
            if let newsEnumerated = self.allNews[0].news.enumerated().first(where: { (data) -> Bool in
                data.element.title == news.title
            }){
                let indexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.allNews[0].news[newsEnumerated.offset].isFavorite = true
                self.favoritesControlSubject.onNext(indexPath)
            }
            if let newsEnumerated = self.allNews[1].news.enumerated().first(where: { (data) -> Bool in
                data.element.title == news.title
            }){
                let indexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.allNews[1].news[newsEnumerated.offset].isFavorite = true
                self.favoritesControlSubject.onNext(indexPath)
            }
            news.isFavorite = true
            return self.database.saveObject(news: news)
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (string) in
                self.toastSubject.onNext("Favorite Added")
                print(string)
                },onError: {[unowned self](error) in
                    print(error)
                    self.realmAlertSubject.onNext(true)
            })
    }
}
