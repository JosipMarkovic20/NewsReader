//
//  DataRepository.swift
//  NewsFactory
//
//  Created by Josip Marković on 07/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

class DataRepository: DataRepositoryProtocol{
    
    let bbcNewsUrl: String =  "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=26a4db9c8a6c41dea9caa401fb634267"
    let ignNewsUrl: String = "https://newsapi.org/v1/articles?source=ign&sortBy=top&apiKey=26a4db9c8a6c41dea9caa401fb634267"
    var alamofire = AlamofireManager()
    
    func getBBCNews() -> Observable<[News]>{
        return alamofire.getNewsAlamofireWay(jsonUrlString: bbcNewsUrl)
    }
    
    func getIGNNews() -> Observable<[News]>{
        return alamofire.getNewsAlamofireWay(jsonUrlString: ignNewsUrl)
    }
}

protocol DataRepositoryProtocol {
    var alamofire: AlamofireManager { get set}
    func getBBCNews() -> Observable<[News]>
    func getIGNNews() -> Observable<[News]>
}
