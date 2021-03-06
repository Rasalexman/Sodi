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

internal final class Sodi {
    internal typealias Storage = [String : Holder]
    internal typealias Modules = Set<String>
    
    private static var localStorage: Storage = Storage()
    private static var localModules: Modules = Modules()
    
    private init() {}
    
    private static func synced(_ lock: Any, closure: () -> Void) {
        if(objc_sync_enter(lock) == OBJC_SYNC_SUCCESS) {
            closure()
            objc_sync_exit(lock)
        }
    }
    
    internal static func insertHolder(sodiHolder: Holder) {
        let tagWrapper = sodiHolder.tag
        if(!tagWrapper.isEmpty()) {
            let tagName: String = tagWrapper.toString()
            synced(localStorage) {
                let holder = localStorage[tagName]
                if(holder == nil && !tagName.isEmpty) {
                    localStorage[tagName] = sodiHolder
                }
            }
        }
    }
    
    internal static func selectHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        if tagWrapper.isNotEmpty() {
            let tagName: String = tagWrapper.toString()
            synced(localStorage) {
                if let existedHolder = localStorage[tagName] {
                    holder = existedHolder
                }
            }
        }
        return holder
    }
    
    internal static func deleteHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        if tagWrapper.isNotEmpty() {
            let tagName: String = tagWrapper.toString()
            synced(localStorage) {
                if let removedHolder = localStorage.removeValue(forKey: tagName) {
                    holder = removedHolder
                }
            }
        }
        
        return holder
    }
    
    internal static func hasInstance(tagWrapper: TagWrapper) -> Bool {
        var hasInstanceInStorage = false
        let tagName: String = tagWrapper.toString()
        synced(localStorage) {
            hasInstanceInStorage = localStorage[tagName] != nil
        }
        return hasInstanceInStorage
    }
    
    internal static func addModule(sodiModule: ISodiModule) -> Bool {
        let moduleName = sodiModule.toString()
        let hasModule = hasModule(moduleName: moduleName)
        if !hasModule {
            sodiModule.create()
            synced(localModules) {
                localModules.insert(moduleName)
            }
        }
        return !hasModule
    }
    
    internal static func removeModule(sodiModule: ISodiModule) -> Bool {
        let moduleName = sodiModule.toString()
        let hasModule = hasModule(moduleName: moduleName)
        if hasModule {
            sodiModule.destroy()
            synced(localModules) {
                localModules.remove(moduleName)
            }
        }
        return hasModule
    }
    
    internal static func hasModule(moduleName: String) -> Bool {
        var alreadyHasModule = false
        synced(localModules) {
            alreadyHasModule = localModules.contains(moduleName)
        }
        return alreadyHasModule
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
    
    @discardableResult
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
    
    @discardableResult
    func hasModule(moduleName: String) -> Bool {
        return Sodi.hasModule(moduleName: moduleName)
    }
}


public func instance<T: Any>(from: Any? = nil) -> T {
    let tagWrapper = TagWrapper(anyTag: from ?? T.self)
    var holder = Sodi.selectHolder(tagWrapper: tagWrapper)
    return try! holder.getHolderValue()
}


