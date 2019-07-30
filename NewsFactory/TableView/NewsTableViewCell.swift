//
//  NewsTableViewCell.swift
//  NewsFactory
//
//  Created by Josip Marković on 15/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class NewsTableViewCell: UITableViewCell{
    
    //MARK: Properties
    
    let titleText: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 3
        return title
    }()
    
    let newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        return newsImage
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "emptyStar"), for: .normal)
        button.setImage(UIImage(named: "filledStar"), for: .selected)
        return button
    }()
    
    var favoriteClickedDelegate: FavoriteClickDelegate?
    var news: News?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(titleText)
        contentView.addSubview(newsImage)
        contentView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(editFavorites), for: .touchUpInside)
        setupLayout()
    }
    
    
    func setupLayout(){
        newsImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        newsImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 76).isActive = true
        newsImage.widthAnchor.constraint(equalToConstant: 76).isActive = true
        newsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleText.leadingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: 10).isActive = true
        titleText.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func editFavorites(){
        guard let news = self.news else { return }
        favoriteClickedDelegate?.favoriteClicked(newsTitle: news.title)
    }
    
    func configureCell(news: News){
        selectionStyle = .none
        titleText.text = news.title
        let url = URL(string: news.urlToImage)
        let placeholder = UIImage(named: "placeholderImage")
        newsImage.kf.setImage(with: url, placeholder: placeholder)
        favoriteButton.isSelected = news.isFavorite
        self.news = news
    }
}
