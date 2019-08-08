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

class NewsFeedTests: QuickSpec {

    
    override func spec(){
       
        describe("News feed data initialization"){
            var viewModel: NewsFeedViewModelProtocol!
            let disposeBag = DisposeBag()
            let mockDataRepository = MockDataRepository()
            let mockFavoritesDelegate = MockFavoritesDelegate()
            var testScheduler: TestScheduler!
            
            beforeSuite {
                Cuckoo.stub(mockDataRepository){ mock in
                    let testBundle = Bundle(for: NewsFeedTests.self)
                    let bbcNewsURL = testBundle.url(forResource: "BBCResponse", withExtension: "json")!
                    let ignNewsURL = testBundle.url(forResource: "IGNResponse", withExtension: "json")!
                    let bbcData = try! Data(contentsOf: bbcNewsURL)
                    let ignData = try! Data(contentsOf: ignNewsURL)
                    let bbcArticles = try! JSONDecoder().decode(Articles.self, from: bbcData)
                    let ignArticles = try! JSONDecoder().decode(Articles.self, from: ignData)
                    
                    when(mock.getBBCNews()).thenReturn(Observable.just(bbcArticles.articles))
                    when(mock.getIGNNews()).thenReturn(Observable.just(ignArticles.articles))
                }
                
                Cuckoo.stub(mockFavoritesDelegate){ mock in
                    when(mock.editFavorites(news: any())).thenDoNothing()
                }
            }
            context("Testing news feed screen"){
                var loaderObserver: TestableObserver<Bool>!
                
                beforeEach {
                    testScheduler = TestScheduler(initialClock: 1)
                    viewModel = NewsFeedViewModel(dataRepository: mockDataRepository, subscribeScheduler: testScheduler)
                    viewModel.collectAndPrepareData(for: viewModel.getNewsDataSubject).disposed(by: disposeBag)
                    viewModel.manageFavorites(subject: viewModel.manageFavoritesSubject).disposed(by: disposeBag)
                    loaderObserver = testScheduler.createObserver(Bool.self)
                    viewModel.refreshAndLoaderSubject.subscribe(loaderObserver).disposed(by: disposeBag)
                }
                
                it("Testing AllNews Array"){
                    testScheduler.start()
                    viewModel.getNewsDataSubject.onNext(.getNews)
                    expect(viewModel.allNews.count).toEventually(equal(2))
                    expect(viewModel.allNews[0].news.isEmpty).to(beFalse())
                    expect(viewModel.allNews[1].news.isEmpty).to(beFalse())
                }
                
                it("Testing loader"){
                    testScheduler.start()
                    viewModel.getNewsDataSubject.onNext(.getNews)
                    expect(loaderObserver.events.count).toEventually(equal(2))
                    expect(loaderObserver.events[0].value.element).to(beTrue())
                    expect(loaderObserver.events[1].value.element).to(beFalse())
                }
                
                it("Testing refresh control"){
                    testScheduler.start()
                    
                }
                
                it("Testing news content"){
                    testScheduler.start()
                    viewModel.getNewsDataSubject.onNext(.getNews)
                    for element in viewModel.allNews[0].news{
                        expect(element.title).toNot(beNil())
                        expect(element.description).toNot(beNil())
                        expect(element.urlToImage).toNot(beNil())
                        expect(element.isFavorite).toNot(beNil())
                    }
                    for element in viewModel.allNews[1].news{
                        expect(element.title).toNot(beNil())
                        expect(element.description).toNot(beNil())
                        expect(element.urlToImage).toNot(beNil())
                        expect(element.isFavorite).toNot(beNil())
                    }
                }
                
                it("Testing delegates"){
                    testScheduler.start()
                    viewModel.getNewsDataSubject.onNext(.getNews)
                    viewModel.manageFavoritesSubject.onNext(viewModel.allNews[0].news[0])
                    verify(mockFavoritesDelegate).editFavorites(news: any())
                }
            }
        }    
    }
}
