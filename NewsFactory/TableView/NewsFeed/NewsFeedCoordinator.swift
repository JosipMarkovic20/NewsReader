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
        viewModel = NewsFeedViewModel()
        viewController = NewsTableViewController(viewModel: viewModel)
    }
    
    func start() {
    }
    
}
