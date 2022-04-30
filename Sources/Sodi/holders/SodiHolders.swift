//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

protocol Holder {
    var tag: TagWrapper {get}
    func getInstance() -> Any?
    func clear() -> Bool
}

internal final class SingleHolder<T: Any> : Holder {
    var tag: TagWrapper
    private var instanceCreator: LambdaWithReturn<T>? = nil
    private var instance: T? = nil
    
    init(tagWrapper: TagWrapper, creator: @escaping LambdaWithReturn<T>) {
        tag = tagWrapper
        instanceCreator = creator
    }
    
    func getInstance() -> Any? {
        if let currentInstance = instanceCreator?.self() {
            self.instance = currentInstance
            self.instanceCreator = nil
        }
        return instance
    }
    
    func clear() -> Bool {
        let hasInstance = instance != nil || instanceCreator != nil
        instanceCreator = nil
        instance = nil
        return hasInstance
    }
}

internal final class ProviderHolder<T: Any> : Holder {
    var tag: TagWrapper
    private var provider: LambdaWithReturn<T>? = nil
    
    init(tagWrapper: TagWrapper, creator: @escaping LambdaWithReturn<T>) {
        tag = tagWrapper
        provider = creator
    }
    
    func getInstance() -> Any? {
        return provider?.self()
    }
    
    func clear() -> Bool {
        let hasProvider = provider != nil
        provider = nil
        return hasProvider
    }
}

internal final class EmptyHolder : Holder {
    var tag: TagWrapper
    init(tagWrapper: TagWrapper) {
        tag = tagWrapper
    }
    
    func getInstance() -> Any? {
       return nil
    }
    
    func clear() -> Bool{
        return false
    }
}

extension Holder {
    
    mutating func getHolderValue<T: Any>() throws -> T {
        if let holderInstance = (self.getInstance() as? T) {
            return holderInstance
        }
        
        throw SodiError.holderNotInitialized(message: "There is no binding holder for tag '\(self.tag.toString())")
    }
}
