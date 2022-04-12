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

final class Sodi : SodiStorage {
    
    internal lazy var storage: Storage = Storage()
    
    // Concurrent synchronization queue
    internal let queue: DispatchQueue = DispatchQueue(label: "SodiStorage.queue", attributes: .concurrent)
    //
    private init() {}
    //
    private static var instance: SodiStorage = Sodi()
    
    private static func synced(_ lock: SodiStorage, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    internal static func insertHolder(tagWrapper: TagWrapper, sodiHolder: Holder) {
        synced(instance) {
            instance.insertHolder(tagWrapper: tagWrapper, sodiHolder: sodiHolder)
        }
    }
    
    internal static func selectHolder(tagWrapper: TagWrapper) -> Holder {
        return instance.selectHolder(tagWrapper: tagWrapper)
    }
    
    internal static func deleteHolder(tagWrapper: TagWrapper) -> Holder {
        return instance.deleteHolder(tagWrapper: tagWrapper)
    }
    
    internal static func hasInstance(tagWrapper: TagWrapper) -> Bool {
        return instance.hasInstance(tagWrapper: tagWrapper)
    }
}

public func bindSingle<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = TagWrapper(anyTag: (to ?? T.self))
    let holder = SingleHolder(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

public func bindProvider<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = TagWrapper(anyTag: to ?? T.self)
    let holder = ProviderHolder(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

public func unbind(from: Any) -> Bool {
    let tagWrapper = TagWrapper(anyTag: from)
    let holder = Sodi.deleteHolder(tagWrapper: tagWrapper)
    return holder.clear()
}

public func hasInstance(from: Any) -> Bool {
    let tagWrapper = TagWrapper(anyTag: from)
    return Sodi.hasInstance(tagWrapper: tagWrapper)
}

public func instance<T: Any>(from: Any? = nil) -> T {
    let tagWrapper = TagWrapper(anyTag: from ?? T.self)
    var holder = Sodi.selectHolder(tagWrapper: tagWrapper)
    return try! holder.getHolderValue()
}
