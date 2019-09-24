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

class NewsDetailsViewModel: ViewModelType {

    struct Input{
        var news: News
        var checkForFavoritesSubject: PublishSubject<Bool>
    }
    
    struct Output{
        var favoriteStatusSubject: PublishSubject<Bool>
    }
    
    public var input: Input?
    public var output: Output?
    var disposables: [Disposable] = []
    
    
    init(news: News) {
        self.input?.news = news
    }
    
    func transform(input: NewsDetailsViewModel.Input) -> NewsDetailsViewModel.Output {
        disposables.append(checkForFavorites(subject: input.checkForFavoritesSubject))
        
        let output = Output(favoriteStatusSubject: PublishSubject())
        self.input = input
        self.output = output
        
        return output
    }
    
    func checkForFavorites(subject: PublishSubject<Bool>) -> Disposable{
        return subject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.output?.favoriteStatusSubject.onNext(bool)
            })
        
    }
}
