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
        return "http://localhost:8000/api/apps"
    }
    
    static var token:String {
        return "your-auth-token-here"
    }
    
}
