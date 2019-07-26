//
//  AlamofireManager.swift
//  NewsFactory
//
//  Created by Josip Marković on 24/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Alamofire
import RxSwift
import RxCocoa

class AlamofireManager {
    
    let jsonUrlString: String =  "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=aeeabfe03a71457ebf1167aa96751e37"
    
    func getNewsAlamofireWay() -> Observable<[News]>{
        
        return Observable.create{[unowned self] observer in
            Alamofire.request(self.jsonUrlString)
                .validate()
                .responseJSON { response in
                    do {
                        guard let data = response.data else { return }
                        let articles = try JSONDecoder().decode(Articles.self, from: data)
                        observer.onNext(articles.articles)
                        observer.onCompleted()
                    } catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                        observer.onError(jsonErr)
                    }
            }
            return Disposables.create{
                Alamofire.request(self.jsonUrlString).cancel()
            }
        }
    }
}
