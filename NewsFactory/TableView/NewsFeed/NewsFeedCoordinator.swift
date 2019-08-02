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
    
    var navigationController: UINavigationController?
    let viewModel: NewsFeedViewModel
    let viewController: NewsTableViewController
    
    init(navigationController :UINavigationController) {
        self.navigationController = navigationController
        viewModel = NewsFeedViewModel()
        viewController = NewsTableViewController(viewModel: viewModel)
    }
    
    func start() {
    }
    
}
