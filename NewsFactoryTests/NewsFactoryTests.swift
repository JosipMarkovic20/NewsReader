//
//  NewsFactoryTests.swift
//  NewsFactoryTests
//
//  Created by Josip Marković on 15/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.
//

import XCTest
@testable import NewsFactory
import Cuckoo
import Quick
import Nimble
import RxSwift

class NewsFactoryTests: QuickSpec {

    
    override func spec(){
       
        let mock = MockDataRepository()
        guard let bbcPath = Bundle.main.path(forResource: "BBCResponse", ofType: "json") else { return }
        guard let ignPath = Bundle.main.path(forResource: "IGNResponse", ofType: "json") else { return }
        
        
        describe("Testing network requests"){
            context("Testing BBC news response"){
                stub(mock) { stub in
                   
                    
                }
            }
            
        }
        
    }
}
