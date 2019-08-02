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
    let navigationController: UINavigationController
    let news: News
    let delegate: FavoritesDelegate
    
    init(navController: UINavigationController, news: News, delegate: FavoritesDelegate){
        self.navigationController = navController
        self.news = news
        self.delegate = delegate
    }
    
    func start(){
        childCoordinators.append(self)
        let detailsView: NewsDetailsViewController = NewsDetailsViewController(news: news, delegate: delegate)
        detailsView.coordinator = self
        self.navigationController.pushViewController(detailsView, animated: false)
    }
}

extension NewsDetailsCoordinator: ParentCoordinatorDelegate, CoordinatorDelegate{
    
    
    func childHasFinished(coordinator: Coordinator) {
        free(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }
}
