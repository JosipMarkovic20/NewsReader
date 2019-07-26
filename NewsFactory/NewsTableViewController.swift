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
    var news = [News]()
    let cellIdentifier = "NewsTableViewCell"
    let alamofire = AlamofireManager()
    var loader: UIAlertController?
    let standardUserDefaults = UserDefaults.standard
    private let refreshControl = UIRefreshControl()
    let database = RealmManager()
    let disposeBag = DisposeBag()
    var favoritesDelegate: FavoritesDelegate?
    var favoriteEdit: ((News) -> Void)?
    let tableReloadSubject = PublishSubject<Bool>()
    let getNewsSubject = PublishSubject<Bool>()
    let refreshAndLoaderSubject = PublishSubject<Bool>()
    let alertSubject = PublishSubject<Bool>()
    
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataToShow()
    }
    
    func setupUI(){
        navigationItem.title = "Factory"
        self.navigationController?.navigationBar.barStyle = .black
        self.view.addSubview(tableView)
        setupTableView()
        setupRefreshControl()
        setupConstraints()
        refreshAndLoaderSubject.onNext(true)
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
        refreshControl.addTarget(self, action: #selector(getNewsSubjectFunction), for: .valueChanged)
    }
    
    func getDataToShow(){
        let lastKnownTime = standardUserDefaults.integer(forKey: "Current time")
        if Int(Date().timeIntervalSince1970)-lastKnownTime>300 || news.isEmpty{
            getNewsSubjectFunction()
        }
    }
    
    func saveCurrentTime(){
        let currentTime = Date().timeIntervalSince1970
        standardUserDefaults.set(currentTime, forKey: "Current time")
    }
    
    // MARK: - Table view data source
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
        let singleNews = news[indexPath.row]
        cell.favoriteClickedDelegate = self
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
        
        refreshAndLoaderSubject
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
        
        alertSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.showAlert()
            }).disposed(by: disposeBag)
    }
    
    @objc func getNewsSubjectFunction(){
        getNewsSubject.onNext(true)
    }
    
    func combineObservables(for subject: PublishSubject<Bool>) -> Disposable{
        return subject.flatMap({ (<#Bool#>) -> ObservableConvertibleType in
            Observable.zip(alamofire.getNewsAlamofireWay(), database.getObjects()) { (articles, favNews) in
                return(articles, favNews)
            }
        })
        .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (news, realmNews) -> [News] in
                let newsFeedArray = self.createScreenData(news: news, realmNews: realmNews)
                return newsFeedArray
            }).subscribe(onNext: { newsFeed in
                self.news = newsFeed
                self.tableReloadSubject.onNext(true)
                self.refreshAndLoaderSubject.onNext(false)
                self.saveCurrentTime()
            }, onError: { [unowned self] error in
                self.alertSubject.onNext(true)
                self.refreshAndLoaderSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    func createScreenData(news: [News], realmNews: [RealmNews]) -> [News]{
        for favoriteNews in realmNews{
            if let indexOfMainNews = news.firstIndex(where: {$0.title==favoriteNews.realmTitle}){
                news[indexOfMainNews].isFavorite = true
            }
        }
        return news
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Something went wrong. Check your network.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[unowned self](action:UIAlertAction!) in self.getNewsSubjectFunction() }))
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
}

extension NewsTableViewController: FavoriteClickDelegate{
    func favoriteClicked(newsTitle: String) {
        guard let indexOfMainNews = news.firstIndex(where: {$0.title==newsTitle}) else {return}
        favoriteEdit?(news[indexOfMainNews])
    }
}
