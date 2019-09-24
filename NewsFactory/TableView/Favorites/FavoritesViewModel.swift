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

class FavoritesViewModel: ViewModelType{
    
    struct Input{
        let loadFavoritesSubject: PublishSubject<Bool>
        let manageFavoritesSubject: PublishSubject<News>
    }
    
    struct Output{
        let tableReloadSubject: PublishSubject<Bool>
        var news: [News]
        let tableViewSubject: PublishSubject<FavoritesTableViewSubjectEnum>
    }
    
    struct Dependencies{
        let database: RealmManager
    }
    
    private let dependencies: Dependencies
    public var input: Input?
    public var output: Output?
    var disposables: [Disposable] = []
    
    init(dependencies: Dependencies){
        self.dependencies = dependencies
    }
    
    
    func transform(input: FavoritesViewModel.Input) -> FavoritesViewModel.Output {
        disposables.append(loadFavorites(subject: input.loadFavoritesSubject))
        disposables.append(manageFavorites(subject: input.manageFavoritesSubject))
        
        let output = Output(tableReloadSubject: PublishSubject(), news: [], tableViewSubject: PublishSubject())
        self.input = input
        self.output = output
        return output
    }
    
    func loadFavorites(subject: PublishSubject<Bool>) -> Disposable{
        output?.news.removeAll()
        return subject.flatMap({[unowned self] (bool) -> Observable<[RealmNews]> in
            self.dependencies.database.getObjects()
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (results) -> [News] in
                let favoriteNewsResult = self.createScreenData(results: results)
                return favoriteNewsResult
            })
            .subscribe(onNext: {[unowned self] (results) in
                self.output?.news = results
                self.output?.tableReloadSubject.onNext(true)
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
                self.output?.news.append(news)
                guard let newsEnumerated = self.output?.news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title
                }) else {return Observable.just("Object not found!")}
                let newIndexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.output?.tableViewSubject.onNext(.rowInsert([newIndexPath]))
                return Observable.just("Favorite added to favorites screen")
            }else{
                guard let newsEnumerated = self.output?.news.enumerated().first(where: { (data) -> Bool in
                    data.element.title == news.title
                }) else {return Observable.just("Object not found")}
                self.output?.news.remove(at: newsEnumerated.offset)
                let newIndexPath: IndexPath = IndexPath(row: newsEnumerated.offset, section: 0)
                self.output?.tableViewSubject.onNext(.rowRemove([newIndexPath]))
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
