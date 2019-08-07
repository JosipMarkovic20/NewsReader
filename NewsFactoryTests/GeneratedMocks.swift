// MARK: - Mocks generated from file: NewsFactory/Networking/DataRepository.swift at 2019-08-07 13:32:39 +0000

//
//  DataRepository.swift
//  NewsFactory
//
//  Created by Josip Marković on 07/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.

import Cuckoo
@testable import NewsFactory

import Foundation
import RxSwift


 class MockDataRepository: DataRepository, Cuckoo.ClassMock {
    
     typealias MocksType = DataRepository
    
     typealias Stubbing = __StubbingProxy_DataRepository
     typealias Verification = __VerificationProxy_DataRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: DataRepository?

     func enableDefaultImplementation(_ stub: DataRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     override func getNews(url: String) -> Observable<[News]> {
        
    return cuckoo_manager.call("getNews(url: String) -> Observable<[News]>",
            parameters: (url),
            escapingParameters: (url),
            superclassCall:
                
                super.getNews(url: url)
                ,
            defaultCall: __defaultImplStub!.getNews(url: url))
        
    }
    

	 struct __StubbingProxy_DataRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getNews<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.ClassStubFunction<(String), Observable<[News]>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: url) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDataRepository.self, method: "getNews(url: String) -> Observable<[News]>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_DataRepository: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getNews<M1: Cuckoo.Matchable>(url: M1) -> Cuckoo.__DoNotUse<(String), Observable<[News]>> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: url) { $0 }]
	        return cuckoo_manager.verify("getNews(url: String) -> Observable<[News]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class DataRepositoryStub: DataRepository {
    

    

    
     override func getNews(url: String) -> Observable<[News]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[News]>).self)
    }
    
}

