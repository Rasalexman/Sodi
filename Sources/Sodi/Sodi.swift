//
//  Sodi.swift
//
//
//  Created by Alexander on 12.04.2022.
//
#if SWIFT_PACKAGE
import Foundation
#endif

typealias LambdaWithReturn<T: Any> = () -> T

final class Sodi : SodiStorage {
    
    lazy var storage: Storage = Storage()
    
    // Concurrent synchronization queue
    let queue: DispatchQueue = DispatchQueue(label: "SodiStorage.queue", attributes: .concurrent)
    
    private init() {}
    
    private static var instance: SodiStorage = Sodi()
    
    private static func synced(_ lock: SodiStorage, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    static func insertHolder(tagWrapper: SodiTagWrapper, sodiHolder: SodiHolder) {
        synced(instance) {
            instance.insertHolder(tag: tagWrapper, sodiHolder: sodiHolder)
        }
    }
    
    static func selectHolder(tagWrapper: SodiTagWrapper) -> SodiHolder {
        return instance.selectHolder(tagWrapper: tagWrapper)
    }
    
    static func deleteHolder(tagWrapper: SodiTagWrapper) -> SodiHolder {
        return instance.deleteHolder(tagWrapper: tagWrapper)
    }
    
    static func hasInstance(tagWrapper: SodiTagWrapper) -> Bool {
        return instance.hasInstance(tagWrapper: tagWrapper)
    }
}

func bindSingle<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
    let holder = SodiSingle(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

func bindProvider<T: Any>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
    let holder = SodiProvider(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

public func unbind<T: Any>(from: Any? = nil) -> T? {
    let tagWrapper = createTagWrapper(toTag: from, name: "\(T.self)")
    var holder = Sodi.deleteHolder(tagWrapper: tagWrapper)
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

private func createTagWrapper(toTag: Any? = nil, name: String) -> SodiTagWrapper {
    var tagName: String = name
    if let obj = toTag {
        tagName = "\(obj.self)"
    }
    return SodiTagWrapper(tagName: tagName)
}
