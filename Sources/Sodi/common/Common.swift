//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

enum SodiError : Error {
    case holderNotInitialized(message: String)
}
