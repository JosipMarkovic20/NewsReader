//
//  RealmManager.swift
//  NewsFactory
//
//  Created by Josip Marković on 17/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//
import Foundation
import RealmSwift
import RxSwift

class RealmManager {
    let realm = try? Realm()
    enum Errors: Error{
        case error
    }
    
    // delete particular object
    func deleteObject(news: News) -> Observable<String> {
        guard let realmObject = self.realm?.object(ofType: RealmNews.self, forPrimaryKey: news.title) else { return Observable.just("Object not found!") }
        do{
            try self.realm?.write {
                self.realm?.delete(realmObject)
            }
        }catch{
            print(error)
            return Observable.error(error)
        }
        return Observable.just("Object deleted!")
    }
    
    //Save object
    func saveObject(news: News) -> Observable<String> {
        let realmObject = RealmNews().setRealmNews(news: news)
        do{
            try realm?.write{ 
                realm?.add(realmObject)
            }
        }catch{
            print(error)
            return Observable.error(error)
        }
        return Observable.just("Object Saved!")
    }
    
    //Returns an array as Results<object>?
    func getObjects() -> Observable<[RealmNews]> {
        var favoritesArray: [RealmNews] = []
        guard let favoriteObjects = realm?.objects(RealmNews.self) else { return Observable.just(favoritesArray) }
        for favorite in favoriteObjects{
            favoritesArray.append(favorite)
        }
        return Observable.just(favoritesArray)
    }
}
