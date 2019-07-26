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
    let bbcNewsUrl: String =  "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=aeeabfe03a71457ebf1167aa96751e37"
    let ignNewsUrl: String = "https://newsapi.org/v1/articles?source=ign&sortBy=top&apiKey=aeeabfe03a71457ebf1167aa96751e37"
    var bbcNews = [News]()
    var ignNews = [News]()
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
    let ignNewsSelectSubject = PublishSubject<Bool>()
    let bbcNewsSelectSubject = PublishSubject<Bool>()
    var bbcSelected: Bool = true
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var ignButton: UIButton = {
        let ignButton = UIButton()
        ignButton.translatesAutoresizingMaskIntoConstraints = false
        ignButton.setTitle("IGN News", for: .normal)
        ignButton.setTitleColor(UIColor(red: 0.054, green: 0.25, blue: 1, alpha: 1.0), for: .normal)
        ignButton.setTitleColor(.gray, for: .highlighted)
        return ignButton
    }()
    
    var bbcButton: UIButton = {
        let bbcButton = UIButton()
        bbcButton.translatesAutoresizingMaskIntoConstraints = false
        bbcButton.setTitle("BBC News", for: .normal)
        bbcButton.setTitleColor(UIColor(red: 0.054, green: 0.25, blue: 1, alpha: 1.0), for: .normal)
        bbcButton.setTitleColor(.gray, for: .highlighted)
        return bbcButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupUI()
        collectAndPrepareData(for: getNewsSubject).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataToShow()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        navigationItem.title = "Factory"
        self.navigationController?.navigationBar.barStyle = .black
        self.view.addSubview(tableView)
        self.view.addSubview(ignButton)
        self.view.addSubview(bbcButton)
        setupTableView()
        setupRefreshControl()
        setupConstraints()
        bbcButton.addTarget(self, action: #selector(selectBbcNews), for: .touchUpInside)
        ignButton.addTarget(self, action: #selector(selectIgnNews), for: .touchUpInside)
        
    }
    
    func setupTableView(){
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupConstraints(){
        bbcButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        bbcButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        bbcButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        ignButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        ignButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        ignButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        tableView.topAnchor.constraint(equalTo: bbcButton.bottomAnchor, constant: 15).isActive = true
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
        if Int(Date().timeIntervalSince1970)-lastKnownTime>300 || bbcNews.isEmpty{
            refreshAndLoaderSubject.onNext(true)
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
        if bbcSelected {
            return bbcNews.count
        }else{
            return ignNews.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        let singleNews: News
        if bbcSelected{
            singleNews = bbcNews[indexPath.row]
        }else{
            singleNews = ignNews[indexPath.row]
        }
        cell.favoriteClickedDelegate = self
        cell.configureCell(news: singleNews)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsToShow: News
        if bbcSelected{
            newsToShow = bbcNews[indexPath.row]
        }else{
            newsToShow = ignNews[indexPath.row]
        }
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
        
        ignNewsSelectSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.tableReloadSubject.onNext(true)
            }).disposed(by: disposeBag)
        
        
        bbcNewsSelectSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                self.tableReloadSubject.onNext(true)
            }).disposed(by: disposeBag)
    }
    
    @objc func getNewsSubjectFunction(){
        getNewsSubject.onNext(true)
    }
    
    @objc func selectBbcNews(){
        bbcSelected = true
        bbcNewsSelectSubject.onNext(true)
    }
    
    @objc func selectIgnNews(){
        bbcSelected = false
        ignNewsSelectSubject.onNext(true)
    }
    
    func collectAndPrepareData(for subject: PublishSubject<Bool>) -> Disposable{
        return subject.flatMap({[unowned self] (bool) -> Observable<([News], [News], [RealmNews])> in
            let observable = Observable.zip(self.alamofire.getNewsAlamofireWay(jsonUrlString: self.bbcNewsUrl), self.alamofire.getNewsAlamofireWay(jsonUrlString: self.ignNewsUrl), self.database.getObjects()) { (bbcNews, ignNews, favNews) in
                return(bbcNews, ignNews, favNews)
            }
            return observable
        })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({[unowned self] (bbcNews, ignNews, realmNews) -> ([News],[News]) in
                let bbcNewsFeedArray = self.createScreenData(news: bbcNews, realmNews: realmNews)
                let ignNewsFeedArray = self.createScreenData(news: ignNews, realmNews: realmNews)
                
                return (bbcNewsFeedArray, ignNewsFeedArray)
            }).subscribe(onNext: { [unowned self] (bbcNewsFeed, ignNewsFeed) in
                self.bbcNews = bbcNewsFeed
                self.ignNews = ignNewsFeed
                self.tableReloadSubject.onNext(true)
                self.refreshAndLoaderSubject.onNext(false)
                self.saveCurrentTime()
                }, onError: { [unowned self] error in
                    self.alertSubject.onNext(true)
                    self.refreshAndLoaderSubject.onNext(false)
            })
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
    
    func showRealmAlert(){
        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
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
    
    func addFavorites(news: News){
        if let indexOfMainNews = self.bbcNews.firstIndex(where: {$0.title==news.title}) {
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            self.bbcNews[indexOfMainNews].isFavorite = true
            news.isFavorite = true
            self.database.saveObject(news: news)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (string) in
                    self.showToast(controller: self, message: "Favorite added.", seconds: 1)
                    print(string)
                }, onError: {[unowned self](error) in
                    print(error)
                    self.showRealmAlert()
                }).disposed(by: disposeBag)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        if let indexOfMainNews = self.ignNews.firstIndex(where: {$0.title==news.title}) {
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            self.ignNews[indexOfMainNews].isFavorite = true
            news.isFavorite = true
            self.database.saveObject(news: news)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: {[unowned self] (string) in
                    self.showToast(controller: self, message: "Favorite added.", seconds: 1)
                    print(string)
                },onError: {[unowned self](error) in
                    print(error)
                    self.showRealmAlert()
                }).disposed(by: disposeBag)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    func removeFavorites(news: News){
        if let indexOfMainNews = self.bbcNews.firstIndex(where: {$0.title==news.title}) {
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            self.bbcNews[indexOfMainNews].isFavorite = false
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        if let indexOfMainNews = self.ignNews.firstIndex(where: {$0.title==news.title}) {
            let indexPath: IndexPath = IndexPath(row: indexOfMainNews, section: 0)
            self.ignNews[indexOfMainNews].isFavorite = false
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.database.deleteObject(news: news)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (string) in
                self.showToast(controller: self, message: "Favorite removed.", seconds: 1)
                print(string)
            },onError: {[unowned self](error) in
                print(error)
                self.showRealmAlert()
            }).disposed(by: disposeBag)
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
}

extension NewsTableViewController: FavoriteClickDelegate{
    func favoriteClicked(newsTitle: String) {
        if let indexOfMainNews = bbcNews.firstIndex(where: {$0.title==newsTitle}) {
            favoriteEdit?(bbcNews[indexOfMainNews])
        }
        if let indexOfMainNews = ignNews.firstIndex(where: {$0.title==newsTitle}) {
            favoriteEdit?(ignNews[indexOfMainNews])
        }
    }
}
