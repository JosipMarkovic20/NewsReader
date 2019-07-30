//
//  FavoritesTableViewController.swift
//  NewsFactory
//
//  Created by Josip Marković on 17/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import Realm
import RxSwift
import RxCocoa

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let database = RealmManager()
    var news = [News]()
    let cellIdentifier = "NewsTableViewCell"
    var favoritesDelegate: FavoritesDelegate?
    var favoriteEdit: (News) -> Void = {news in }
    let disposeBag = DisposeBag()
    let tableReloadSubject = PublishSubject<Bool>()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        loadFavorites()
        setupUI()
        setupSubscriptions()
    }
    
    func setupUI(){
        navigationItem.title = "Factory"
        self.navigationController?.navigationBar.barStyle = .black
        self.view.addSubview(tableView)
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView(){
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints(){
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        cell.favoriteClickedDelegate = self
        let singleNews = news[indexPath.row]
        cell.configureCell(news: singleNews)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsToShow = news[indexPath.row]
        guard let delegate = favoritesDelegate else {return}
        let detailsView: NewsDetailsViewController = NewsDetailsViewController(news: newsToShow, delegate: delegate)
        self.navigationController?.pushViewController(detailsView, animated: false)
    }
    
    func setupSubscriptions(){
        tableReloadSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func loadFavorites(){
        news.removeAll()
        database.getObjects()
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (results) -> [News] in
                let favoriteNewsResult = self.createScreenData(results: results)
                return favoriteNewsResult
            })
            .subscribe(onNext: {[unowned self] (results) in
                self.news = results
                self.tableReloadSubject.onNext(true)
                }
            ).disposed(by: disposeBag)
    }
    
    func createScreenData(results: [RealmNews]) -> [News]{
        var favoriteNewsResult = [News]()
        let results = results
        for favoriteNews in results{
            let favoriteNewsForArray = News(title: favoriteNews.realmTitle, description: favoriteNews.realmDescription, urlToImage: favoriteNews.realmUrlToImage, author: favoriteNews.realmAuthor, url: favoriteNews.realmUrl, publishedAt: favoriteNews.realmPublishedAt)
            favoriteNewsForArray.isFavorite = true
            favoriteNewsResult.append(favoriteNewsForArray)
        }
        return favoriteNewsResult
    }
    
    func addFavorites(news: News){
        self.news.append(news)
        guard let indexOfNews = self.news.firstIndex(where: {$0.title==news.title}) else {return}
        let newIndexPath: IndexPath = IndexPath(row: indexOfNews, section: 0)
        self.tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func removeFavorites(news: News){
        guard let indexOfFavorite = self.news.firstIndex(where: {$0.title==news.title}) else {return}
        self.news.remove(at: indexOfFavorite)
        let newIndexPath: IndexPath = IndexPath(row: indexOfFavorite, section: 0)
        self.tableView.deleteRows(at: [newIndexPath], with: .automatic)
    }
    
}


extension FavoritesTableViewController: FavoriteClickDelegate{
    func favoriteClicked(newsTitle: String) {
        guard let indexOfMainNews = news.firstIndex(where: {$0.title==newsTitle}) else {return}
        self.favoritesDelegate?.editFavorites(news: news[indexOfMainNews])
    }
}
