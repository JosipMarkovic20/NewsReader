//
//  FavoritesDelegate.swift
//  NewsFactory
//
//  Created by Josip Marković on 19/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation

protocol FavoritesDelegate{
    func editFavorites(news: News)
}

protocol FavoriteClickDelegate{
    func favoriteClicked(newsTitle: String)
}
