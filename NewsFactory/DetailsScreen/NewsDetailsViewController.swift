//
//  NewsDetailsViewController.swift
//  NewsFactory
//
//  Created by Josip Marković on 15/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import RxSwift

class NewsDetailsViewController: UIViewController {
    
    //MARK: Properties
    let newsImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let newsTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .boldSystemFont(ofSize: 20)
        title.numberOfLines = 0
        return title
    }()
    
    let newsDescription: UILabel = {
        let description = UILabel()
        description.isUserInteractionEnabled = false
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = .systemFont(ofSize: 16)
        description.textColor = .gray
        description.numberOfLines = 0
        return description
    }()
    
    var delegate: FavoritesDelegate
    let viewModel: NewsDetailsViewModel
    let disposeBag = DisposeBag()
    
    init(news: News, delegate: FavoritesDelegate){
        viewModel = NewsDetailsViewModel(news: news)
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        setDataToViews(news: news)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubscriptions()
        viewModel.checkForFavoritesSubject.onNext(true)
        viewModel.checkForFavorites(subject: viewModel.checkForFavoritesSubject).disposed(by: disposeBag)
    }
    
    func setDataToViews(news: News){
        let url = URL(string: news.urlToImage)
        let placeholder = UIImage(named: "placeholderImage")
        newsImage.kf.setImage(with: url, placeholder: placeholder)
        newsTitle.text = news.title
        newsDescription.text = news.description
        navigationItem.title = news.title
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubview(newsImage)
        view.addSubview(newsTitle)
        view.addSubview(newsDescription)
        setupConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(editFavorites))
    }
    
    func setupConstraints(){
        newsImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 20).isActive = true
        newsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        newsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 20).isActive = true
        newsDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        newsDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc func editFavorites(){
        delegate.editFavorites(news: viewModel.news)
        viewModel.checkForFavoritesSubject.onNext(true)
    }
    
    func setupSubscriptions(){
        viewModel.favoriteStatusSubject
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (bool) in
                if self.viewModel.news.isFavorite{
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 1, green: 0.87, blue: 0, alpha: 1)
                }else{
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }).disposed(by: disposeBag)
    }
    
    
}
