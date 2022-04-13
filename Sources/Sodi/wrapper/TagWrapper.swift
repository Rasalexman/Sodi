//
//  SodiTagWrapper.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

final class TagWrapper {
    private let name: String
    
    init(anyTag: Any) {
        name = "\(anyTag)"
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
}
