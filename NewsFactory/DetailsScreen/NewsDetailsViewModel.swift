//
//  NewsDetailsViewModel.swift
//  NewsFactory
//
//  Created by Josip Marković on 31/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NewsDetailsViewModel {
    
    var news: News
    var favoriteStatusSubject = PublishSubject<Bool>()
    var checkForFavoritesSubject = PublishSubject<Bool>()
    
    init(news: News) {
        self.news = news
    }
    
    func checkForFavorites(subject: PublishSubject<Bool>) -> Disposable{
        
        return subject.flatMap({ (bool) -> Observable<Bool> in
            return Observable.just(bool)
        }).observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.favoriteStatusSubject.onNext(bool)
            })
        
    }
}
