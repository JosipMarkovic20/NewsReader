//
//  NewsTableViewController.swift
//  NewsFactory
//
//  Created by Josip Marković on 15/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import RxSwift

class NewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    let cellIdentifier = "NewsTableViewCell"
    var loader: UIAlertController?
    private let refreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()
    var favoritesDelegate: FavoritesDelegate?
    
    let viewModel: NewsFeedViewModel
    var detailsDelegate: DetailsDelegate?
    let output: NewsFeedViewModel.Output
    let input: NewsFeedViewModel.Input
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: NewsFeedViewModel){
        self.viewModel = viewModel
        self.input = NewsFeedViewModel.Input(toggleExpandSubject: PublishSubject(), fetchNewsSubject: PublishSubject(), getNewsDataSubject: PublishSubject(), favoriteEdit: {_ in }, favoriteClickSubject: PublishSubject(), detailsDelegateSubject: PublishSubject(), manageFavoritesSubject: PublishSubject())
        self.output = viewModel.transform(input: self.input)
        super.init(nibName: nil,bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubscriptions()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.input?.fetchNewsSubject.onNext(.getNews)
    }
    
    func setupUI(){
        view.backgroundColor = .white
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
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews(){
        viewModel.input?.fetchNewsSubject.onNext(.refreshNews)
    }
 
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (viewModel.output?.allNews.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (viewModel.output?.allNews[section].isExpanded)!{
            return (viewModel.output?.allNews[section].news.count)!
            
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.output?.allNews[section].title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 20)
        button.addTarget(self, action: #selector(toggleExpanding), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    @objc func toggleExpanding(button: UIButton){
        viewModel.input?.toggleExpandSubject.onNext(button)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleNews = (viewModel.output?.allNews[indexPath.section].news[indexPath.row])!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell.")
        }
        cell.favoriteClosure = {[unowned self] newsTitle in
            self.viewModel.input?.favoriteClickSubject.onNext(newsTitle)
        }
        cell.configureCell(news: singleNews)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.input?.detailsDelegateSubject.onNext(indexPath)
    }
    
    func setupSubscriptions(){
        
        viewModel.output?.refreshAndLoaderSubject
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
        
        viewModel.output?.sectionExpandSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (enumCase) in
                switch enumCase{
                case .sectionExpand(let indexPath):
                    self.tableView.insertRows(at: indexPath, with: .automatic)
                case .sectionCollapse(let indexPath):
                    self.tableView.deleteRows(at: indexPath, with: .automatic)
                }
            }).disposed(by: disposeBag)
        
        viewModel.input?.toggleExpandSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (button) in
                self.viewModel.toggleExpand(button: button)
            }).disposed(by: disposeBag)
        
        viewModel.output?.tableViewControlSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (enumCase) in
                switch enumCase{
                case .reloadRows(let indexPath):
                    self.tableView.reloadRows(at: indexPath, with: .automatic)
                case .reloadTable:
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        viewModel.output?.toastSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (string) in
                self.showToast(controller: self, message: string, seconds: 1)
            }).disposed(by: disposeBag)
        
        viewModel.input?.fetchNewsSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (enumCase) in
                switch enumCase{
                case .getNews:
                    self.viewModel.getDataToShow()
                case .refreshNews:
                    print("refresh")
                    self.viewModel.input?.getNewsDataSubject.onNext(.refreshNews)
                }
            }).disposed(by: disposeBag)
        
        viewModel.output?.alertPopUpSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (enumCase) in
                self.showAlert(alertEnumCase: enumCase)
            }).disposed(by: disposeBag)
        
    }
    
    func showAlert(alertEnumCase: AlertSubjectEnum){
        switch alertEnumCase{
        case .alamofireAlert:
            let alert = UIAlertController(title: "Error", message: "Something went wrong. Check your network.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {[unowned self](action:UIAlertAction!) in self.refreshNews() }))
            self.present(alert, animated: true)
        case .realmAlert:
            let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
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


