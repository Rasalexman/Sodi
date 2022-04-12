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
    let name: String
    
    init(tagName: String) {
        name = tagName
    }
}
