//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

import Foundation

typealias LambdaWithReturn<T: Any> = () -> T

enum SodiError : Error {
    case holderNotInitialized(message: String)
}
