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
    
    private init() {}
    
    private static var instance: SodiStorage = Sodi()
    
    private static func synced(_ lock: SodiStorage, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    internal static func insertHolder(tagWrapper: TagWrapper, sodiHolder: Holder) {
        synced(instance) {
            instance.insertHolder(tag: tagWrapper, sodiHolder: sodiHolder)
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
    let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
    let holder = SingleHolder(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

public func bindProvider<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
    let holder = ProviderHolder(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

public func unbind<T: Any>(from: Any? = nil) -> T? {
    let tagWrapper = createTagWrapper(toTag: from, name: "\(T.self)")
    let holder = Sodi.deleteHolder(tagWrapper: tagWrapper)
    return holder.getInstance() as? T ?? nil
}

public func hasInstance(from: Any) -> Bool {
    let tagWrapper = createTagWrapper(toTag: from, name: "\(from.self)")
    return Sodi.hasInstance(tagWrapper: tagWrapper)
}

public func instance<T: Any>(from: Any? = nil) -> T {
    let tagWrapper = createTagWrapper(toTag: from, name: "\(T.self)")
    var holder = Sodi.selectHolder(tagWrapper: tagWrapper)
    return try! holder.getHolderValue()
}

private func createTagWrapper(toTag: Any? = nil, name: String) -> TagWrapper {
    var tagName: String = name
    if let obj = toTag {
        tagName = "\(obj.self)"
    }
    return TagWrapper(tagName: tagName)
}
