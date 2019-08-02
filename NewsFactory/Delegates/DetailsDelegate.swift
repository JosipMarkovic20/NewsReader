//
//  DetailsDelegate.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation


protocol DetailsDelegate {
    func showDetailedNews(news: News, delegate: FavoritesDelegate)
}
