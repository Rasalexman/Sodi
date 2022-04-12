//
//  Sodi.swift
//
//
//  Created by Alexander on 12.04.2022.
//
#if SWIFT_PACKAGE
import Foundation
#endif

final class Sodi : SodiStorage, ISodi {
    
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
