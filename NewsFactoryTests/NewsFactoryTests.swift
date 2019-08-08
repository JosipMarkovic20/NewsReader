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
import RxTest

class NewsFactoryTests: QuickSpec {

    
    override func spec(){
       
        describe("News feed data initialization"){
            var viewModel: NewsFeedViewModelProtocol!
            let disposeBag = DisposeBag()
            let mock = MockDataRepository()
            var testScheduler: TestScheduler!
            
            beforeSuite {
                Cuckoo.stub(mock){ mock in
                    let testBundle = Bundle(for: NewsFactoryTests.self)
                    let bbcNewsURL = testBundle.url(forResource: "BBCResponse", withExtension: "json")!
                    let ignNewsURL = testBundle.url(forResource: "IGNResponse", withExtension: "json")!
                    let bbcData = try! Data(contentsOf: bbcNewsURL)
                    let ignData = try! Data(contentsOf: ignNewsURL)
                    let bbcArticles = try! JSONDecoder().decode(Articles.self, from: bbcData)
                    let ignArticles = try! JSONDecoder().decode(Articles.self, from: ignData)
                    
                    when(mock.getBBCNews()).thenReturn(Observable.just(bbcArticles.articles))
                    when(mock.getIGNNews()).thenReturn(Observable.just(ignArticles.articles))
                }
            }
            context("Prepare news for download"){
                    
                    testScheduler = TestScheduler(initialClock: 1)
                    
                    viewModel = NewsFeedViewModel(dataRepository: mock, subscribeScheduler: testScheduler)
                    
                    viewModel.collectAndPrepareData(for: viewModel.getNewsDataSubject).disposed(by: disposeBag)
                
                
                it("Testing BBC news"){
                    testScheduler.start()
                    viewModel.getNewsDataSubject.onNext(.getNews)
                    expect(viewModel.allNews[0].news.count).to(equal(10))
                    expect(viewModel.allNews[1].news.count).to(equal(10))
                }
            }
        }    
    }
}
