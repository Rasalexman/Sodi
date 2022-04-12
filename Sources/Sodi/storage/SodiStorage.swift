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

protocol SodiStorage {
    var storage: Storage {get set}
    var queue: DispatchQueue {get}
}

extension SodiStorage {
    
    mutating func insertHolder(tag: TagWrapper, sodiHolder: Holder) {
        queue.sync {
            let tagName: String = tag.name
            let holder = self.storage[tagName]
            if(holder == nil) {
                self.storage[tagName] = sodiHolder
            }
        }
    }
    
    mutating func selectHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        queue.sync {
            let tagName: String = tagWrapper.name
            if let existedHolder = self.storage[tagName] {
                holder = existedHolder
            }
        }
        return holder
    }
    
    mutating func deleteHolder(tagWrapper: TagWrapper) -> Holder {
        var holder: Holder = EmptyHolder(tagWrapper: tagWrapper)
        queue.sync {
            let tagName: String = tagWrapper.name
            if let removedHolder = self.storage.removeValue(forKey: tagName) {
                holder = removedHolder
            }
        }
        return holder
    }
    
    mutating func hasInstance(tagWrapper: TagWrapper) -> Bool {
        let tagName: String = tagWrapper.name
        return self.storage[tagName] != nil
    }
}
