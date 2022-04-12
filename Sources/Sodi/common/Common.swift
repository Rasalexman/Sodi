//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

#if SWIFT_PACKAGE
import Foundation
#endif

typealias LambdaWithReturn<T: Any> = () -> T

enum SodiError : Error {
    case holderNotInitialized(message: String)
}
