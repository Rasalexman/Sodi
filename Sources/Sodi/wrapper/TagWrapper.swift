//
//  SodiTagWrapper.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

public class TagWrapper : ITagger {
    private let name: String
    
    init(anyTag: Any) {
        if let stringTag = anyTag as? String {
            name = stringTag
        } else {
            name = "\(anyTag)"
        }
    }
    
    func toString() -> String {
        return name
    }
    
    func isEmpty() -> Bool {
        return name.isEmpty
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    public static func ==(lhs: TagWrapper, rhs: TagWrapper) -> Bool {
        return lhs.toString() == rhs.toString()
    }
}
