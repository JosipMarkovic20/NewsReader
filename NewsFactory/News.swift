//
//  News.swift
//  NewsFactory
//
//  Created by Josip Marković on 15/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import Realm


struct Articles: Codable{
    //MARK: Properties
    let status: String
    let source: String
    let sortBy: String
    let articles: [News]
}

class News: Codable{
    //MARK: Properties
    
    let title: String
    let description: String
    let urlToImage: String
    let author: String
    let url: String
    let publishedAt: String?
    var isFavorite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlToImage
        case author
        case url
        case publishedAt
    }
    
    init(title: String, description: String, urlToImage: String, author: String, url: String, publishedAt: String) {
        self.isFavorite = false
        self.title = title
        self.description = description
        self.urlToImage = urlToImage
        self.author = author
        self.url = url
        self.publishedAt = publishedAt
    }
}





