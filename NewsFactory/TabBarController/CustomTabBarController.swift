//
//  CustomTabBarController.swift
//  NewsFactory
//
//  Created by Josip Marković on 17/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    
    func setupNavigationBar(){
        navigationItem.title = "Factory"
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.054, green: 0.25, blue: 1, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    
}


