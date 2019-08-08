// MARK: - Mocks generated from file: NewsFactory/Networking/DataRepository.swift at 2019-08-08 10:45:50 +0000

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

