//
//  NewsTableViewController.swift
//  NewsFactory
//
//  Created by Josip Marković on 15/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import Realm
import Alamofire
import RxSwift
import RxCocoa


class NewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    let cellIdentifier = "NewsTableViewCell"
    var loader: UIAlertController?
    let standardUserDefaults = UserDefaults.standard
    private let refreshControl = UIRefreshControl()
    var favoritesDelegate: FavoritesDelegate?
    var favoriteEdit: ((News) -> Void)?
    let viewModel = NewsFeedViewModel()
    let disposeBag = DisposeBag()
    
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupUI()
        funcToDispose()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getDataToShow()
    }
    
    func setupUI(){
        navigationItem.title = "Factory"
        self.navigationController?.navigationBar.barStyle = .black
        self.view.addSubview(tableView)
        setupTableView()
        setupRefreshControl()
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
    
    func setupRefreshControl(){
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(viewModel.getNewsSubjectFunction), for: .valueChanged)
    }
    

    
    
    // MARK: - Table view data source
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
        cell.favoriteClickedDelegate = self
        cell.configureCell(news: singleNews)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsToShow = viewModel.news[indexPath.row]
        guard let delegate = favoritesDelegate else {return}
        let detailsView: NewsDetailsViewController = NewsDetailsViewController(news: newsToShow, delegate: delegate)
        self.navigationController?.pushViewController(detailsView, animated: false)
    }
    
    func setupSubscriptions(){
        
        viewModel.refreshAndLoaderSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                if bool{
                    self.loader = self.showLoader()
                }else{
                    self.loader?.dismiss(animated: true, completion: nil)
                    self.refreshControl.endRefreshing()
                }
            }).disposed(by: disposeBag)
        
        viewModel.alertSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.showAlert()
            }).disposed(by: disposeBag)
        
        viewModel.tableViewSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (tableViewSubjectEnum) in
                switch tableViewSubjectEnum {
                case .tableViewReload:
                    self.tableView.reloadData()
                case .tableViewRowReload(let indexPath):
                    self.tableView.reloadRows(at: indexPath, with: .automatic)
                }
            }).disposed(by: disposeBag)
    }
    
    func funcToDispose(){
        viewModel.collectAndPrepareData(for: viewModel.getNewsSubject).disposed(by: disposeBag)
        viewModel.removeFavorites(subject: viewModel.removeFavoritesSubject).disposed(by: disposeBag)
        viewModel.addFavorites(subject: viewModel.addFavoriteSubject).disposed(by: disposeBag)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Check your network.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[unowned self](action:UIAlertAction!) in self.viewModel.getNewsSubjectFunction() }))
        self.present(alert, animated: true)
    }
    
    func showLoader() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: false, completion: nil)
        return alert
    }
    
    func removeFavorites(news: News){
        viewModel.removeFavoritesSubject.onNext(news)
    }
    
    func addFavorites(news: News){
        viewModel.addFavoriteSubject.onNext(news)
    }
}

extension NewsTableViewController: FavoriteClickDelegate{
    func favoriteClicked(newsTitle: String) {
        guard let indexOfMainNews = viewModel.news.firstIndex(where: {$0.title==newsTitle}) else {return}
        favoriteEdit?(viewModel.news[indexOfMainNews])
    }
}
