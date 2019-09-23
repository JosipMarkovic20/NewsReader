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

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "NewsTableViewCell"
    var favoritesDelegate: FavoritesDelegate?
    var favoriteEdit: (News) -> Void = {news in }
    let disposeBag = DisposeBag()
    let viewModel: FavoritesViewModel
    var detailsDelegate: DetailsDelegate?
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: FavoritesViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil,bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        funcToDispose()
        setupUI()
        setupSubscriptions()
        viewModel.loadFavoritesSubject.onNext(true)
    }
    
    func funcToDispose(){
        viewModel.loadFavorites(subject: viewModel.loadFavoritesSubject).disposed(by: disposeBag) 
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
        return viewModel.news.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleNews = viewModel.news[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        cell.configureCell(news: singleNews)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsToShow = viewModel.news[indexPath.row]
        guard let delegate = favoritesDelegate else {return}
        detailsDelegate?.showDetailedNews(news: newsToShow, delegate: delegate)
    }
    
    func setupSubscriptions(){
        viewModel.tableReloadSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.tableViewSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (favoritesTableViewSubjectEnum) in
                switch favoritesTableViewSubjectEnum {
                case .rowRemove(let indexPath):
                    self.tableView.deleteRows(at: indexPath, with: .automatic)
                case .rowInsert(let indexPath):
                    self.tableView.insertRows(at: indexPath, with: .automatic)
                }
            }).disposed(by: disposeBag)
    }

}


extension FavoritesTableViewController: FavoriteClickDelegate{
    func favoriteClicked(newsTitle: String) {
        if let indexOfMainNews = viewModel.news.enumerated().first(where: { (data) -> Bool in
            data.element.title == newsTitle
        }){
            self.favoritesDelegate?.editFavorites(news: viewModel.news[indexOfMainNews.offset])
        }
        
    }
}
