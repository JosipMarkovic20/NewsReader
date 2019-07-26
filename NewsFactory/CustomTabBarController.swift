//
//  CustomTabBarController.swift
//  NewsFactory
//
//  Created by Josip Marković on 17/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomTabBarController: UITabBarController{
    
    let newsNavigationController = UINavigationController()
    let newsFeedView = NewsTableViewController()
    
    let favoritesNavigationController = UINavigationController()
    let favoritesView = FavoritesTableViewController()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
        setupClosures()
    }
    
    func setupControllers(){
        newsNavigationController.viewControllers = [newsFeedView]
        newsNavigationController.title = "News"
        newsNavigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        newsFeedView.favoritesDelegate = self
        
        favoritesNavigationController.viewControllers = [favoritesView]
        favoritesNavigationController.title = "Favorites"
        favoritesNavigationController.tabBarItem.image = UIImage(named: "star")
        favoritesView.favoritesDelegate = self
        
        viewControllers = [newsNavigationController, favoritesNavigationController]
    }
    
    func setupClosures(){
        favoritesView.favoriteEdit = {[unowned self] (news) in
            self.favoritesControl(news: news)        }
        
        newsFeedView.favoriteEdit = {[unowned self] (news) in
            self.favoritesControl(news: news)
        }
    }
    
    func favoritesControl(news: News){
        if news.isFavorite {
            self.favoritesView.removeFavorites(news: news)
            self.newsFeedView.removeFavorites(news: news)
        }else {
            self.newsFeedView.addFavorites(news: news)
            self.favoritesView.addFavorites(news: news)
        }
    }
}

extension CustomTabBarController: FavoritesDelegate{
    
    func editFavorites(news: News){
        favoritesControl(news: news)
    }
}
