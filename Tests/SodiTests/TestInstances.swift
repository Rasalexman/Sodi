//
//  File.swift
//  
//
//  Created by Alexander on 12.04.2022.
//

import Foundation

protocol Binded {
    var keyWord: String {get}
    func sayHello() -> String
}

protocol SingleBinded : Binded {
    
}

protocol ProviderBinded : Binded {
    
}

class SingleBindedInstance : SingleBinded {
    
    let HELLO_SINGLE = "Hello, I Single Binded Instance"
    var keyWord: String { return HELLO_SINGLE }
    
    func sayHello() -> String {
        return HELLO_SINGLE
    }
    
    
}

class ProviderBindedInstance : ProviderBinded {
    
    let HELLO_PROVIDER = "Hello, I Provider Binded Instance"
    var keyWord: String { return HELLO_PROVIDER }
    
    func sayHello() -> String {
        return HELLO_PROVIDER
    }
    
    
}
