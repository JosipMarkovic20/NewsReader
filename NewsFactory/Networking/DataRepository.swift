//
//  DataRepository.swift
//  NewsFactory
//
//  Created by Josip Marković on 07/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RxSwift

class DataRepository{
    
    let alamofire = AlamofireManager()
    
    func getNews(url: String) -> Observable<[News]>{
        return alamofire.getNewsAlamofireWay(jsonUrlString: url)
    }
    
    
}
