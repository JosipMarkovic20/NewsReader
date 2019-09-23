// MARK: - Mocks generated from file: NewsFactory/Delegates/DetailsDelegate.swift at 2019-09-23 06:34:38 +0000

//
//  DetailsDelegate.swift
//  NewsFactory
//
//  Created by Josip Marković on 02/08/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.

import Cuckoo
@testable import NewsFactory

import Foundation


 class MockDetailsDelegate: DetailsDelegate, Cuckoo.ProtocolMock {
    
     typealias MocksType = DetailsDelegate
    
     typealias Stubbing = __StubbingProxy_DetailsDelegate
     typealias Verification = __VerificationProxy_DetailsDelegate

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: DetailsDelegate?

     func enableDefaultImplementation(_ stub: DetailsDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func showDetailedNews(news: News, delegate: FavoritesDelegate)  {
        
    return cuckoo_manager.call("showDetailedNews(news: News, delegate: FavoritesDelegate)",
            parameters: (news, delegate),
            escapingParameters: (news, delegate),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.showDetailedNews(news: news, delegate: delegate))
        
    }
    

	 struct __StubbingProxy_DetailsDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func showDetailedNews<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(news: M1, delegate: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(News, FavoritesDelegate)> where M1.MatchedType == News, M2.MatchedType == FavoritesDelegate {
	        let matchers: [Cuckoo.ParameterMatcher<(News, FavoritesDelegate)>] = [wrap(matchable: news) { $0.0 }, wrap(matchable: delegate) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockDetailsDelegate.self, method: "showDetailedNews(news: News, delegate: FavoritesDelegate)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_DetailsDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func showDetailedNews<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(news: M1, delegate: M2) -> Cuckoo.__DoNotUse<(News, FavoritesDelegate), Void> where M1.MatchedType == News, M2.MatchedType == FavoritesDelegate {
	        let matchers: [Cuckoo.ParameterMatcher<(News, FavoritesDelegate)>] = [wrap(matchable: news) { $0.0 }, wrap(matchable: delegate) { $0.1 }]
	        return cuckoo_manager.verify("showDetailedNews(news: News, delegate: FavoritesDelegate)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class DetailsDelegateStub: DetailsDelegate {
    

    

    
     func showDetailedNews(news: News, delegate: FavoritesDelegate)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: NewsFactory/Delegates/FavoritesDelegate.swift at 2019-09-23 06:34:38 +0000

//
//  FavoritesDelegate.swift
//  NewsFactory
//
//  Created by Josip Marković on 19/07/2019.
//  Copyright © 2019 Josip Marković. All rights reserved.

import Cuckoo
@testable import NewsFactory

import Foundation


 class MockFavoritesDelegate: FavoritesDelegate, Cuckoo.ProtocolMock {
    
     typealias MocksType = FavoritesDelegate
    
     typealias Stubbing = __StubbingProxy_FavoritesDelegate
     typealias Verification = __VerificationProxy_FavoritesDelegate

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FavoritesDelegate?

     func enableDefaultImplementation(_ stub: FavoritesDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func editFavorites(news: News)  {
        
    return cuckoo_manager.call("editFavorites(news: News)",
            parameters: (news),
            escapingParameters: (news),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.editFavorites(news: news))
        
    }
    

	 struct __StubbingProxy_FavoritesDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func editFavorites<M1: Cuckoo.Matchable>(news: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(News)> where M1.MatchedType == News {
	        let matchers: [Cuckoo.ParameterMatcher<(News)>] = [wrap(matchable: news) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFavoritesDelegate.self, method: "editFavorites(news: News)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_FavoritesDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func editFavorites<M1: Cuckoo.Matchable>(news: M1) -> Cuckoo.__DoNotUse<(News), Void> where M1.MatchedType == News {
	        let matchers: [Cuckoo.ParameterMatcher<(News)>] = [wrap(matchable: news) { $0 }]
	        return cuckoo_manager.verify("editFavorites(news: News)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class FavoritesDelegateStub: FavoritesDelegate {
    

    

    
     func editFavorites(news: News)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}



 class MockFavoriteClickDelegate: FavoriteClickDelegate, Cuckoo.ProtocolMock {
    
     typealias MocksType = FavoriteClickDelegate
    
     typealias Stubbing = __StubbingProxy_FavoriteClickDelegate
     typealias Verification = __VerificationProxy_FavoriteClickDelegate

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: FavoriteClickDelegate?

     func enableDefaultImplementation(_ stub: FavoriteClickDelegate) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func favoriteClicked(newsTitle: String)  {
        
    return cuckoo_manager.call("favoriteClicked(newsTitle: String)",
            parameters: (newsTitle),
            escapingParameters: (newsTitle),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.favoriteClicked(newsTitle: newsTitle))
        
    }
    

	 struct __StubbingProxy_FavoriteClickDelegate: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func favoriteClicked<M1: Cuckoo.Matchable>(newsTitle: M1) -> Cuckoo.ProtocolStubNoReturnFunction<(String)> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: newsTitle) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockFavoriteClickDelegate.self, method: "favoriteClicked(newsTitle: String)", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_FavoriteClickDelegate: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func favoriteClicked<M1: Cuckoo.Matchable>(newsTitle: M1) -> Cuckoo.__DoNotUse<(String), Void> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: newsTitle) { $0 }]
	        return cuckoo_manager.verify("favoriteClicked(newsTitle: String)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class FavoriteClickDelegateStub: FavoriteClickDelegate {
    

    

    
     func favoriteClicked(newsTitle: String)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
}


// MARK: - Mocks generated from file: NewsFactory/Networking/DataRepository.swift at 2019-09-23 06:34:38 +0000

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
    

    
    
    
     override var alamofire: AlamofireManager {
        get {
            return cuckoo_manager.getter("alamofire",
                superclassCall:
                    
                    super.alamofire
                    ,
                defaultCall: __defaultImplStub!.alamofire)
        }
        
        set {
            cuckoo_manager.setter("alamofire",
                value: newValue,
                superclassCall:
                    
                    super.alamofire = newValue
                    ,
                defaultCall: __defaultImplStub!.alamofire = newValue)
        }
        
    }
    

    

    
    
    
     override func getBBCNews() -> Observable<[News]> {
        
    return cuckoo_manager.call("getBBCNews() -> Observable<[News]>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getBBCNews()
                ,
            defaultCall: __defaultImplStub!.getBBCNews())
        
    }
    
    
    
     override func getIGNNews() -> Observable<[News]> {
        
    return cuckoo_manager.call("getIGNNews() -> Observable<[News]>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                super.getIGNNews()
                ,
            defaultCall: __defaultImplStub!.getIGNNews())
        
    }
    

	 struct __StubbingProxy_DataRepository: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var alamofire: Cuckoo.ClassToBeStubbedProperty<MockDataRepository, AlamofireManager> {
	        return .init(manager: cuckoo_manager, name: "alamofire")
	    }
	    
	    
	    func getBBCNews() -> Cuckoo.ClassStubFunction<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataRepository.self, method: "getBBCNews() -> Observable<[News]>", parameterMatchers: matchers))
	    }
	    
	    func getIGNNews() -> Cuckoo.ClassStubFunction<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataRepository.self, method: "getIGNNews() -> Observable<[News]>", parameterMatchers: matchers))
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
	
	    
	    
	    var alamofire: Cuckoo.VerifyProperty<AlamofireManager> {
	        return .init(manager: cuckoo_manager, name: "alamofire", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func getBBCNews() -> Cuckoo.__DoNotUse<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getBBCNews() -> Observable<[News]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getIGNNews() -> Cuckoo.__DoNotUse<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getIGNNews() -> Observable<[News]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class DataRepositoryStub: DataRepository {
    
    
     override var alamofire: AlamofireManager {
        get {
            return DefaultValueRegistry.defaultValue(for: (AlamofireManager).self)
        }
        
        set { }
        
    }
    

    

    
     override func getBBCNews() -> Observable<[News]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[News]>).self)
    }
    
     override func getIGNNews() -> Observable<[News]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[News]>).self)
    }
    
}



 class MockDataRepositoryProtocol: DataRepositoryProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = DataRepositoryProtocol
    
     typealias Stubbing = __StubbingProxy_DataRepositoryProtocol
     typealias Verification = __VerificationProxy_DataRepositoryProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: DataRepositoryProtocol?

     func enableDefaultImplementation(_ stub: DataRepositoryProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
     var alamofire: AlamofireManager {
        get {
            return cuckoo_manager.getter("alamofire",
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.alamofire)
        }
        
        set {
            cuckoo_manager.setter("alamofire",
                value: newValue,
                superclassCall:
                    
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    ,
                defaultCall: __defaultImplStub!.alamofire = newValue)
        }
        
    }
    

    

    
    
    
     func getBBCNews() -> Observable<[News]> {
        
    return cuckoo_manager.call("getBBCNews() -> Observable<[News]>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getBBCNews())
        
    }
    
    
    
     func getIGNNews() -> Observable<[News]> {
        
    return cuckoo_manager.call("getIGNNews() -> Observable<[News]>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getIGNNews())
        
    }
    

	 struct __StubbingProxy_DataRepositoryProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    var alamofire: Cuckoo.ProtocolToBeStubbedProperty<MockDataRepositoryProtocol, AlamofireManager> {
	        return .init(manager: cuckoo_manager, name: "alamofire")
	    }
	    
	    
	    func getBBCNews() -> Cuckoo.ProtocolStubFunction<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataRepositoryProtocol.self, method: "getBBCNews() -> Observable<[News]>", parameterMatchers: matchers))
	    }
	    
	    func getIGNNews() -> Cuckoo.ProtocolStubFunction<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockDataRepositoryProtocol.self, method: "getIGNNews() -> Observable<[News]>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_DataRepositoryProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	    
	    var alamofire: Cuckoo.VerifyProperty<AlamofireManager> {
	        return .init(manager: cuckoo_manager, name: "alamofire", callMatcher: callMatcher, sourceLocation: sourceLocation)
	    }
	    
	
	    
	    @discardableResult
	    func getBBCNews() -> Cuckoo.__DoNotUse<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getBBCNews() -> Observable<[News]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func getIGNNews() -> Cuckoo.__DoNotUse<(), Observable<[News]>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getIGNNews() -> Observable<[News]>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class DataRepositoryProtocolStub: DataRepositoryProtocol {
    
    
     var alamofire: AlamofireManager {
        get {
            return DefaultValueRegistry.defaultValue(for: (AlamofireManager).self)
        }
        
        set { }
        
    }
    

    

    
     func getBBCNews() -> Observable<[News]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[News]>).self)
    }
    
     func getIGNNews() -> Observable<[News]>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<[News]>).self)
    }
    
}

