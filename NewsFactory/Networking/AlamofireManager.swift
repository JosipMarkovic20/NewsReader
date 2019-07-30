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
    
    
    
    func getNewsAlamofireWay(jsonUrlString: String) -> Observable<[News]>{
        
        return Observable.create{observer in
            Alamofire.request(jsonUrlString)
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
                Alamofire.request(jsonUrlString).cancel()
            }
        }
    }
}
