//
//  ApiProtocol.swift
//  Crayon
//
//  Created by leetao on 2025/8/18.
//

import Foundation


protocol ApiProtocol {
    static var baseURL: String { get }
    static var token:String { get}
}

extension ApiProtocol {
    static var baseURL: String {
        return "https://api.myapp.com/v1"
    }
    
    static var token:String {
        return ""
    }
    
}
