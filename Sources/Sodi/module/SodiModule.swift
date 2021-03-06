//
//  File.swift
//  
//
//  Created by Alexander on 18.04.2022.
//
#if SWIFT_PACKAGE
import Foundation
#endif

public typealias ModuleCreator = (ISodi) -> Void

public protocol ISodiModule : ISodi {
    var instances: Set<TagWrapper> {get set}
    var creator: ModuleCreator {get}
    func toString() -> String
    func destroy()
}

extension ISodiModule {
    
    mutating func addTagWrapper(tagWrapper: TagWrapper) {
        instances.insert(tagWrapper)
    }
    
    func create() {
        creator(self)
    }
}

final class SodiModule : ISodiModule {
    private let moduleTag: TagWrapper
    internal var instances: Set<TagWrapper> = Set()
    internal var creator: ModuleCreator
    
    init(moduleName: Any, moduleCreator: @escaping ModuleCreator) {
        moduleTag = TagWrapper(anyTag: moduleName)
        creator = moduleCreator
    }
    
    func toString() -> String {
        return moduleTag.toString()
    }
    
    func destroy() {
        instances.forEach { tagWrapper in
            unbind(from: tagWrapper.toString())
        }
        instances.removeAll()
    }
    
    
    //    public func hash(into hasher: inout Hasher) {
    //        hasher.combine(moduleName)
    //    }
    //
    //    public static func ==(lhs: SodiModule, rhs: SodiModule) -> Bool {
    //        return lhs.toString() == rhs.toString()
    //    }
}

public func sodiModule(moduleName: Any, moduleCreator: @escaping ModuleCreator) -> ISodiModule {
    return SodiModule(moduleName: moduleName, moduleCreator: moduleCreator)
}
