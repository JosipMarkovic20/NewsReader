//
//  FavoritesViewModel.swift
//  NewsFactory
//
//  Created by Josip Marković on 30/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import Realm
import RxSwift

class FavoritesViewModel{
    
    let tableReloadSubject = PublishSubject<Bool>()
    let database = RealmManager()
    var news = [News]()
    let loadFavoritesSubject = PublishSubject<Bool>()
    let tableViewSubject = PublishSubject<FavoritesTableViewSubjectEnum>()
    let addNewsSubject = PublishSubject<News>()
    let removeNewsSubject = PublishSubject<News>()
    
    
    
    func loadFavorites(subject: PublishSubject<Bool>) -> Disposable{
        news.removeAll()
        return subject.flatMap({ (bool) -> Observable<[RealmNews]> in
            self.database.getObjects()
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (results) -> [News] in
                let favoriteNewsResult = self.createScreenData(results: results)
                return favoriteNewsResult
            })
            .subscribe(onNext: {[unowned self] (results) in
                self.news = results
                self.tableReloadSubject.onNext(true)
                }
        )
    }
    
    func createScreenData(results: [RealmNews]) -> [News]{
        var favoriteNewsResult = [News]()
        let results = results
        for favoriteNews in results{
            let favoriteNewsForArray = News(title: favoriteNews.realmTitle, description: favoriteNews.realmDescription, urlToImage: favoriteNews.realmUrlToImage, author: favoriteNews.realmAuthor, url: favoriteNews.realmUrl, publishedAt: favoriteNews.realmPublishedAt)
            favoriteNewsForArray.isFavorite = true
            favoriteNewsResult.append(favoriteNewsForArray)
        }
        return favoriteNewsResult
    }
    
    func addFavorites(subject: PublishSubject<News>) -> Disposable{
        return subject.flatMap({ (news) -> Observable<News> in
            return Observable.just(news)
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (news) in
                self.news.append(news)
                guard let indexOfNews = self.news.firstIndex(where: {$0.title==news.title}) else {return}
                let newIndexPath: IndexPath = IndexPath(row: indexOfNews, section: 0)
                self.tableViewSubject.onNext(FavoritesTableViewSubjectEnum.rowInsert([newIndexPath]))
            })
    }
    
    func removeFavorites(subject: PublishSubject<News>) -> Disposable{
        return subject.flatMap({ (news) -> Observable<News> in
            return Observable.just(news)
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (news) in
                guard let indexOfFavorite = self.news.firstIndex(where: {$0.title==news.title}) else {return}
                self.news.remove(at: indexOfFavorite)
                let newIndexPath: IndexPath = IndexPath(row: indexOfFavorite, section: 0)
                self.tableViewSubject.onNext(FavoritesTableViewSubjectEnum.rowRemove([newIndexPath]))
            })
    }
}
