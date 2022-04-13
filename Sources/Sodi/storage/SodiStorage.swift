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
    
    mutating func insertHolder(tagWrapper: TagWrapper, sodiHolder: Holder) {
        queue.sync {
            let tagWrapper = sodiHolder.tag
            if(!tagWrapper.isEmpty()) {
                let tagName: String = tagWrapper.toString()
                let holder = self.storage[tagName]
                if(holder == nil && !tagName.isEmpty) {
                    self.storage[tagName] = sodiHolder
                }
            }
        }
    }
    
    mutating func selectHolder(tagWrapper: TagWrapper) -> Holder {
        if(tagWrapper.isNotEmpty()) {
            var selectResult: Holder = EmptyHolder(tagWrapper: tagWrapper)
            queue.sync {
                let tagName: String = tagWrapper.toString()
                if let existedHolder = self.storage[tagName] {
                    selectResult = existedHolder
                }
            }
        }
        
        return EmptyHolder(tagWrapper: tagWrapper)
    }
    
    mutating func deleteHolder(tagWrapper: TagWrapper) -> Holder {
        //
        if(tagWrapper.isNotEmpty()) {
            var deleteResult = EmptyHolder(tagWrapper: tagWrapper)
            queue.sync {
                let tagName: String = tagWrapper.toString()
                if let removedHolder = self.storage.removeValue(forKey: tagName) {
                    deleteResult = removedHolder
                }
            }
        }
        
        return deleteResult
    }
    
    mutating func hasInstance(tagWrapper: TagWrapper) -> Bool {
        let tagName: String = tagWrapper.toString()
        return self.storage[tagName] != nil
    }
}
