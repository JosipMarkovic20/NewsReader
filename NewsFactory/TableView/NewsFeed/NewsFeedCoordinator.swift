//
//  NewsFeedCoordinator.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var presenter: UINavigationController?
    let viewModel: NewsFeedViewModel
    let viewController: NewsTableViewController
    
    init(presenter :UINavigationController) {
        self.presenter = presenter
        viewModel = NewsFeedViewModel(dataRepository: DataRepository())
        viewController = NewsTableViewController(viewModel: viewModel)
        viewController.detailsDelegate = self
    }
    
    func start() {
        
    }
    
}

extension NewsFeedCoordinator: DetailsDelegate, ParentCoordinatorDelegate, CoordinatorDelegate{
    
    func showDetailedNews(news: News, delegate: FavoritesDelegate) {
        
        guard let presenter = self.presenter else { return }
        let detailsCoordinator = NewsDetailsCoordinator(presenter: presenter, news: news, delegate: delegate)
        self.store(coordinator: detailsCoordinator)
        detailsCoordinator.viewController.detailsCoordinatorDelegate = self
        detailsCoordinator.start()
    }
    
    func childHasFinished(coordinator: Coordinator) {
        free(coordinator: coordinator)
    }
    
    func viewControllerHasFinished() {
        childCoordinators.removeAll()
        childHasFinished(coordinator: self)
    }
}
