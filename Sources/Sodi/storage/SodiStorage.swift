//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

typealias Storage = [String : Holder]
typealias Modules = Set<String>

protocol SodiStorage {
    var storage: Storage {get set}
    var modules: Modules {get set}
   // var queue: DispatchQueue {get}
}

extension SodiStorage {
    
    mutating func insertHolder(sodiHolder: Holder) {
        let tagWrapper = sodiHolder.tag
        if(!tagWrapper.isEmpty()) {
            let tagName: String = tagWrapper.toString()
            let holder = self.storage[tagName]
            if(holder == nil && !tagName.isEmpty) {
                self.storage[tagName] = sodiHolder
            }
        }
    }
    
    mutating func selectHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        if tagWrapper.isNotEmpty() {
            let tagName: String = tagWrapper.toString()
            if let existedHolder = self.storage[tagName] {
                holder = existedHolder
            }
        }
        
        return holder
    }
    
    mutating func deleteHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        if tagWrapper.isNotEmpty() {
            let tagName: String = tagWrapper.toString()
            if let removedHolder = self.storage.removeValue(forKey: tagName) {
                holder = removedHolder
            }
        }
        
        return holder
    }
    
    mutating func hasInstance(tagWrapper: TagWrapper) -> Bool {
        let tagName: String = tagWrapper.toString()
        return self.storage[tagName] != nil
    }
    
    mutating func addModule(sodiModule: ISodiModule) -> Bool {
        let hasModule = hasModule(sodiModule: sodiModule)
        if !hasModule {
            sodiModule.create()
            modules.insert(sodiModule.toString())
        }
        return !hasModule
    }
    
    mutating func removeModule(sodiModule: ISodiModule) -> Bool {
        let hasModule = hasModule(sodiModule: sodiModule)
        if hasModule {
            sodiModule.destroy()
            modules.remove(sodiModule.toString())
        }
        return hasModule
    }
    
    mutating func hasModule(sodiModule: ISodiModule) -> Bool {
        return modules.contains(sodiModule.toString())
    }
}
