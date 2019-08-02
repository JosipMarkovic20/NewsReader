//
//  TabBarCoordinator.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TabBarCoordinator: Coordinator{
  
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let disposeBag = DisposeBag()
    var newsFeedController: NewsTableViewController?
    var favoritesController: FavoritesTableViewController?
    let viewController: CustomTabBarController
    
    init(presenter: UINavigationController){
        self.presenter = presenter
        self.viewController = CustomTabBarController()
    }
    
    func start() {
        setupCoordinators()
        setupClosures()
        
    }
    
    func setupCoordinators(){
        let newsFeedCoordinator = createNewsFeedCoordinator()
        let favoritesCoordinator = createFavoritesCoordinator()
        presenter.navigationBar.barStyle = .black
        viewController.setViewControllers([newsFeedCoordinator.viewController, favoritesCoordinator.viewController], animated: true)
        presenter.pushViewController(viewController, animated: true)
    }
    
    func createNewsFeedCoordinator() -> NewsFeedCoordinator{
        let newsFeedCoordinator = NewsFeedCoordinator(navigationController: presenter)
        self.newsFeedController = newsFeedCoordinator.viewController
        guard let newsFeedController = newsFeedController else { return NewsFeedCoordinator(navigationController: presenter)}
        newsFeedController.title = "News"
        newsFeedController.tabBarItem.image = UIImage(named: "news_feed_icon")
        return newsFeedCoordinator
    }
    
    func createFavoritesCoordinator() -> FavoritesCoordinator{
        let favoritesCoordinator = FavoritesCoordinator(navigationController: presenter)
        self.favoritesController = favoritesCoordinator.viewController
        guard let favoritesController = favoritesController else { return FavoritesCoordinator(navigationController: presenter)}
        favoritesController.title = "Favorites"
        favoritesController.tabBarItem.image = UIImage(named: "star")
        return favoritesCoordinator
    }
 
    func setupClosures(){
        
        guard let newsFeedController = newsFeedController else { return }
        guard let favoritesController = favoritesController else { return }
        
        favoritesController.favoriteEdit = {[unowned self] (news) in
            self.favoritesControl(news: news)        }
        
        newsFeedController.favoriteEdit = {[unowned self] (news) in
            self.favoritesControl(news: news)
        }
        
        newsFeedController.favoritesDelegate = self
        favoritesController.favoritesDelegate = self
        newsFeedController.detailsDelegate = self
        favoritesController.detailsDelegate = self
    }
    
    func favoritesControl(news: News){
        
        guard let newsFeedController = newsFeedController else { return }
        guard let favoritesController = favoritesController else { return }
        
        if news.isFavorite {
            favoritesController.removeFavorites(news: news)
            newsFeedController.removeFavorites(news: news)
        }else {
            newsFeedController.addFavorites(news: news)
            favoritesController.addFavorites(news: news)
        }
    }
}

extension TabBarCoordinator: FavoritesDelegate, DetailsDelegate{
    
    func showDetailedNews(news: News, delegate: FavoritesDelegate) {
        let detailsCoordinator = NewsDetailsCoordinator(navController: presenter, news: news, delegate: delegate)
        detailsCoordinator.start()
    }
    
    func editFavorites(news: News){
        favoritesControl(news: news)
    }
}

