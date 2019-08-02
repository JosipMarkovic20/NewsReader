//
//  NewsDetailsCoordinator.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


class NewsDetailsCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let presenter: UINavigationController
    let viewController: NewsDetailsViewController
    
    init(presenter: UINavigationController, news: News, delegate: FavoritesDelegate){
        self.presenter = presenter
        self.viewController = NewsDetailsViewController(news: news, delegate: delegate)
    }
    
    deinit {
        print("deinit: \(self)")
    }
    
    func start(){
        self.presenter.pushViewController(viewController, animated: false)
    }
}
