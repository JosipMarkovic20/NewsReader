//
//  ViewModelType.swift
//  NewsFactory
//
//  Created by Josip Marković on 23/09/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import Foundation



protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
