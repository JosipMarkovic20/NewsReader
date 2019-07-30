//
//  RealmNews.swift
//  NewsFactory
//
//  Created by Josip Marković on 17/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import RealmSwift


class RealmNews: Object{
    //MARK: Properties
    @objc dynamic var realmTitle: String = ""
    @objc dynamic var realmDescription: String = ""
    @objc dynamic var realmUrlToImage: String = ""
    @objc dynamic var realmAuthor: String = ""
    @objc dynamic var realmUrl: String = ""
    @objc dynamic var realmPublishedAt: String = ""
    
    
    func setRealmNews(news: News) -> RealmNews{
        let realmNews = RealmNews()
        realmNews.realmTitle = news.title
        realmNews.realmDescription = news.description
        realmNews.realmUrlToImage = news.urlToImage
        realmNews.realmAuthor = news.author ?? ""
        realmNews.realmUrl = news.url
        realmNews.realmPublishedAt = news.publishedAt ?? ""
        return realmNews
    }
    
    override class func primaryKey() -> String? {
        return "realmTitle"
    }
    
}
