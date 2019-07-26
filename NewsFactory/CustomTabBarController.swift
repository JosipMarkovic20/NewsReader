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
            removeFavorite(news: news)
        }else {
            addFavorite(news: news)
        }
    }
    
    func removeFavorite(news: News){
        if let indexOfMainNews = self.newsFeedView.news.firstIndex(where: {$0.title==news.title}) {
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            self.newsFeedView.news[indexOfMainNews].isFavorite = false
            self.newsFeedView.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.newsFeedView.database.deleteObject(news: news)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (string) in
                print(string)
            }).disposed(by: disposeBag)
        guard let indexOfFavorite = self.favoritesView.news.firstIndex(where: {$0.title==news.title}) else {return}
        self.favoritesView.news.remove(at: indexOfFavorite)
        let newIndexPath: IndexPath = IndexPath(row: indexOfFavorite, section: 0)
        self.favoritesView.tableView.deleteRows(at: [newIndexPath], with: .automatic)
    }
    
    func addFavorite(news: News){
        guard let indexOfMainNews = self.newsFeedView.news.firstIndex(where: {$0.title==news.title}) else {return}
        let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
        self.newsFeedView.news[indexOfMainNews].isFavorite = true
        news.isFavorite = true
        self.newsFeedView.database.saveObject(news: news)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (string) in
                print(string)
            }).disposed(by: disposeBag)
        self.newsFeedView.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.favoritesView.news.append(news)
        guard let indexOfNews = self.favoritesView.news.firstIndex(where: {$0.title==news.title}) else {return}
        let newIndexPath: IndexPath = IndexPath(row: indexOfNews, section: 0)
        self.favoritesView.tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}

extension CustomTabBarController: FavoritesDelegate{
    
    func editFavorites(news: News){
        favoritesControl(news: news)
    }
}
