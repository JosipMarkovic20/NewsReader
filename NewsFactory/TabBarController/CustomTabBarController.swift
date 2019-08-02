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
        
        newsFeedView.viewModel.manageFavorites(subject: newsFeedView.viewModel.manageFavoritesSubject).disposed(by: disposeBag)
        favoritesView.viewModel.manageFavorites(subject: favoritesView.viewModel.manageFavoritesSubject).disposed(by: disposeBag)
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
        newsFeedView.viewModel.manageFavoritesSubject.onNext(news)
        favoritesView.viewModel.manageFavoritesSubject.onNext(news)
    }
}

extension CustomTabBarController: FavoritesDelegate{
    
    func editFavorites(news: News){
        favoritesControl(news: news)
    }
}
