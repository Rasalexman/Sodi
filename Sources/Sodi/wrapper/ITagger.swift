//
//  File.swift
//  
//
//  Created by Alexander on 18.04.2022.
//

import Foundation

protocol ITagger : Hashable {
    func toString() -> String
    func isEmpty() -> Bool
    func isNotEmpty() -> Bool
}
