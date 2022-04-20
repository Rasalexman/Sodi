//
//  Sodi.swift
//
//
//  Created by Alexander on 12.04.2022.
//
#if SWIFT_PACKAGE
import Foundation
#endif

public typealias LambdaWithReturn<T: Any> = () -> T

public protocol ISodi {
    
}

final class Sodi : SodiStorage, ISodi {
    
    internal lazy var storage: Storage = Storage()
    internal lazy var modules: Modules = Modules()
    
    // Concurrent synchronization queue
    //internal let queue: DispatchQueue = Sodi.instanceQueue
    //
    private init() {}
    //
    private static var instance: SodiStorage = Sodi()
    
    private static func synced(_ lock: Any, closure: () -> Void) {
        if(objc_sync_enter(lock) == OBJC_SYNC_SUCCESS) {
            closure()
            objc_sync_exit(lock)
        }
    }
    
    private static let instanceQueue: DispatchQueue = DispatchQueue(label: "SodiStaticStorage.queue")
    
    internal static func insertHolder(sodiHolder: Holder) {
        instanceQueue.async(flags: .barrier) {
            instance.insertHolder(sodiHolder: sodiHolder)
        }
    }
    
    internal static func selectHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        instanceQueue.sync {
            holder = instance.selectHolder(tagWrapper: tagWrapper)
        }
        return holder
    }
    
    internal static func deleteHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        instanceQueue.async(flags: .barrier) {
            holder = instance.deleteHolder(tagWrapper: tagWrapper)
        }
        return holder
    }
    
    internal static func hasInstance(tagWrapper: TagWrapper) -> Bool {
        var hasLocalModule = false
        instanceQueue.sync {
            hasLocalModule = instance.hasInstance(tagWrapper: tagWrapper)
        }
        return hasLocalModule
    }
    
    internal static func addModule(sodiModule: ISodiModule) -> Bool {
        var moduleWasAdded = false
        instanceQueue.sync {
            moduleWasAdded = instance.addModule(sodiModule: sodiModule)
        }
        return moduleWasAdded
    }
    
    internal static func removeModule(sodiModule: ISodiModule) -> Bool {
        var moduleWasDeleted = false
        instanceQueue.sync {
            moduleWasDeleted = instance.removeModule(sodiModule: sodiModule)
        }
        return moduleWasDeleted
    }
}

public extension ISodi {
    
    func bindSingle<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
        let tagWrapper = TagWrapper(anyTag: (to ?? T.self))
        let holder = SingleHolder(tagWrapper: tagWrapper, creator: creater)
        Sodi.insertHolder(sodiHolder: holder)
        if var module = self as? ISodiModule {
            module.addTagWrapper(tagWrapper: tagWrapper)
        }
    }

    func bindProvider<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
        let tagWrapper = TagWrapper(anyTag: to ?? T.self)
        let holder = ProviderHolder(tagWrapper: tagWrapper, creator: creater)
        Sodi.insertHolder(sodiHolder: holder)
        if var module = self as? ISodiModule {
            module.addTagWrapper(tagWrapper: tagWrapper)
        }
    }
    
    @discardableResult
    func unbind(from: Any) -> Bool {
        let tagWrapper = TagWrapper(anyTag: from)
        let holder = Sodi.deleteHolder(tagWrapper: tagWrapper)
        return holder.clear()
    }
    
    func hasInstance(from: Any) -> Bool {
        let tagWrapper = TagWrapper(anyTag: from)
        return Sodi.hasInstance(tagWrapper: tagWrapper)
    }
    
    @discardableResult
    func importModule(sodiModule: ISodiModule) -> Bool {
        return Sodi.addModule(sodiModule: sodiModule)
    }
    
    @discardableResult
    func removeModule(sodiModule: ISodiModule) -> Bool {
        return Sodi.removeModule(sodiModule: sodiModule)
    }
}


public func instance<T: Any>(from: Any? = nil) -> T {
    let tagWrapper = TagWrapper(anyTag: from ?? T.self)
    var holder = Sodi.selectHolder(tagWrapper: tagWrapper)
    return try! holder.getHolderValue()
}


