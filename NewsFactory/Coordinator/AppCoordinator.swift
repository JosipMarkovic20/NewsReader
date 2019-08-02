//
//  AppCoordinator.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation
import UIKit


class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow
    let presenter: UINavigationController
    var tabBarCoordinator: TabBarCoordinator?
    
    
    init(window: UIWindow){
        self.window = window
        self.presenter = UINavigationController()
    }
    
    
    func start() {
        self.tabBarCoordinator = TabBarCoordinator(presenter: self.presenter)
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        
        guard let tabBarCoordinator = tabBarCoordinator else { return }
        self.store(coordinator: tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
