//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

protocol SodiHolder {
    var tag: SodiTagWrapper {get}
    mutating func getInstance() -> Any?
}

final class SodiSingle<T: Any> : SodiHolder {
    var tag: SodiTagWrapper
    private var instanceCreator: LambdaWithReturn<T>? = nil
    private var instance: T? = nil
    
    init(tagWrapper: SodiTagWrapper, creator: @escaping LambdaWithReturn<T>) {
        tag = tagWrapper
        instanceCreator = creator
    }
    
    func getInstance() -> Any? {
        let inst = instanceCreator?.self()
        if let currentInstance = inst {
            self.instance = currentInstance
            self.instanceCreator = nil
        }
        return instance
    }
}

final class SodiProvider<T: Any> : SodiHolder {
    var tag: SodiTagWrapper
    private var provider: LambdaWithReturn<T>? = nil
    
    init(tagWrapper: SodiTagWrapper, creator: @escaping LambdaWithReturn<T>) {
        tag = tagWrapper
        provider = creator
    }
    
    func getInstance() -> Any? {
        return provider?.self()
    }
}

final class SodiEmpty : SodiHolder {
    var tag: SodiTagWrapper
    init(tagWrapper: SodiTagWrapper) {
        tag = tagWrapper
    }
    
    func getInstance() -> Any? {
       return nil
    }
}

extension SodiHolder {
    
    mutating func getHolderValue<T: Any>() throws -> T {
        if let holderInstance = (self.getInstance() as? T) {
            return holderInstance
        }
        
        throw SodiError.holderNotInitialized(message: "There is no binding holder for tag '\(self.tag.name)")
    }
}
