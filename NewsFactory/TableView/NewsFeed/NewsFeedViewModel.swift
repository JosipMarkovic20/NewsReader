//
//  NewsD.swift
//  NewsFactory
//
//  Created by Josip Marković on 30/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire
import RealmSwift
import Realm


class NewsFeedViewModel{
    
    let standardUserDefaults = UserDefaults.standard
    var news = [News]()
    let alamofire = AlamofireManager()
    let bbcNewsUrl: String =  "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=aeeabfe03a71457ebf1167aa96751e37"
    let database = RealmManager()
    let getNewsSubject = PublishSubject<Bool>()
    let refreshAndLoaderSubject = PublishSubject<Bool>()
    let alertSubject = PublishSubject<Bool>()
    let tableViewSubject = PublishSubject<TableViewSubjectEnum>()
    let removeFavoritesSubject = PublishSubject<News>()
    let addFavoriteSubject = PublishSubject<News>()
    
    
    func saveCurrentTime(){
        let currentTime = Date().timeIntervalSince1970
        standardUserDefaults.set(currentTime, forKey: "Current time")
    }
    
    func getDataToShow(){
        let lastKnownTime = standardUserDefaults.integer(forKey: "Current time")
        if Int(Date().timeIntervalSince1970)-lastKnownTime>300 || news.isEmpty{
            refreshAndLoaderSubject.onNext(true)
            getNewsSubjectFunction()
        }
    }
    
    @objc func getNewsSubjectFunction(){
        getNewsSubject.onNext(true)
    }
    
    func collectAndPrepareData(for subject: PublishSubject<Bool>) -> Disposable{
        return subject.flatMap({[unowned self] (bool) -> Observable<([News], [RealmNews])> in
            let observable = Observable.zip(self.alamofire.getNewsAlamofireWay(jsonUrlString: self.bbcNewsUrl), self.database.getObjects()) { (articles, favNews) in
                return(articles, favNews)
            }
            return observable
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (news, realmNews) -> [News] in
                let newsFeedArray = self.createScreenData(news: news, realmNews: realmNews)
                return newsFeedArray
            }).subscribe(onNext: { [unowned self] newsFeed in
                self.news = newsFeed
                self.tableViewSubject.onNext(TableViewSubjectEnum.tableViewReload)
                self.refreshAndLoaderSubject.onNext(false)
                self.saveCurrentTime()
                }, onError: { [unowned self] error in
                    self.alertSubject.onNext(true)
                    self.refreshAndLoaderSubject.onNext(false)
            })
    }
    
    func createScreenData(news: [News], realmNews: [RealmNews]) -> [News]{
        for favoriteNews in realmNews{
            if let indexOfMainNews = news.firstIndex(where: {$0.title==favoriteNews.realmTitle}){
                news[indexOfMainNews].isFavorite = true
            }
        }
        return news
    }
    
    func removeFavorites(subject: PublishSubject<News>) -> Disposable {
        
        return subject.flatMap({ [unowned self] (news) -> Observable<String> in
            guard let indexOfMainNews = self.news.firstIndex(where: {$0.title==news.title}) else {return Observable.just("Error removing object")}
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            let tableViewRowEnum = TableViewSubjectEnum.tableViewRowReload([indexPath])
            self.news[indexOfMainNews].isFavorite = false
            self.tableViewSubject.onNext(tableViewRowEnum)
            return self.database.deleteObject(news: news)
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (string) in
                print(string)
            })
    }
    
    func addFavorites(subject: PublishSubject<News>) -> Disposable {
        return subject.flatMap({ [unowned self] (news) -> Observable<String> in
            guard let indexOfMainNews = self.news.firstIndex(where: {$0.title==news.title}) else {return Observable.just("Error adding object")}
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            let tableViewRowEnum = TableViewSubjectEnum.tableViewRowReload([indexPath])
            self.news[indexOfMainNews].isFavorite = true
            news.isFavorite = true
            self.tableViewSubject.onNext(tableViewRowEnum)
            return self.database.saveObject(news: news)
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (string) in
                print(string)
            })
    }
    
}
