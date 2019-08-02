//
//  FavoritesViewModel.swift
//  NewsFactory
//
//  Created by Josip Marković on 31/07/2019.
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
    let manageFavoritesSubject = PublishSubject<News>()
    
    func loadFavorites(subject: PublishSubject<Bool>) -> Disposable{
        news.removeAll()
        return subject.flatMap({[unowned self] (bool) -> Observable<[RealmNews]> in
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
    
    
    func manageFavorites(subject: PublishSubject<News>) -> Disposable{
        return subject.flatMap({ (news) -> Observable<String> in
            if news.isFavorite{
                self.news.append(news)
                guard let newsEnumerated = self.news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title
                }) else {return Observable.just("Object not found!")}
                let newIndexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.tableViewSubject.onNext(.rowInsert([newIndexPath]))
                return Observable.just("Favorite added to favorites screen")
            }else{
                guard let newsEnumerated = self.news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title
                }) else {return Observable.just("Object not found")}
                self.news.remove(at: newsEnumerated.offset)
                let newIndexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.tableViewSubject.onNext(.rowRemove([newIndexPath]))
                return Observable.just("Favorite removed from favorites screen")
            }
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (string) in
                print(string)
            })
    }
}
