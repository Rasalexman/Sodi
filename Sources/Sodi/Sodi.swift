//
//  Sodi.swift
//
//
//  Created by Alexander on 12.04.2022.
//
#if SWIFT_PACKAGE
import Foundation
#endif

private final class Sodi : SodiStorage {
    
    lazy var storage: Storage = Storage()
    
    // Concurrent synchronization queue
    internal let queue: DispatchQueue = DispatchQueue(label: "SodiStorage.queue", attributes: .concurrent)
    
    private init() {}
    
    private static var instance: SodiStorage = Sodi()
    
    private static func synced(_ lock: SodiStorage, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    internal static func insertHolder(tagWrapper: SodiTagWrapper, sodiHolder: SodiHolder) {
        synced(instance) {
            instance.insertHolder(tag: tagWrapper, sodiHolder: sodiHolder)
        }
    }
    
    internal static func selectHolder(tagWrapper: SodiTagWrapper) -> SodiHolder {
        return instance.selectHolder(tagWrapper: tagWrapper)
    }
    
    internal static func deleteHolder(tagWrapper: SodiTagWrapper) -> SodiHolder {
        return instance.deleteHolder(tagWrapper: tagWrapper)
    }
    
    internal static func hasInstance(tagWrapper: SodiTagWrapper) -> Bool {
        return instance.hasInstance(tagWrapper: tagWrapper)
    }
}

///----- PUBLIC METHODS
/**
 * Bind a instance of generic class to specific object
 */
func bindSingle<T>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
    let holder = SodiSingle(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

func bindProvider<T>(to: Any? = nil, creater: @escaping LambdaWithReturn<T>) {
    let tagWrapper = createTagWrapper(toTag: to, name: "\(T.self)")
    let holder = SodiProvider(tagWrapper: tagWrapper, creator: creater)
    Sodi.insertHolder(tagWrapper: tagWrapper, sodiHolder: holder)
}

func unbind<T: Any>(from: Any? = nil) -> T? {
    let tagWrapper = createTagWrapper(toTag: from, name: "\(T.self)")
    var holder = Sodi.deleteHolder(tagWrapper: tagWrapper)
    return holder.getInstance() as? T ?? nil
}

func hasInstance(from: Any) -> Bool {
    let tagWrapper = createTagWrapper(toTag: from, name: "\(from.self)")
    return Sodi.hasInstance(tagWrapper: tagWrapper)
}

func instance<T: Any>(from: Any? = nil) -> T {
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
