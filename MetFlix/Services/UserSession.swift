//
//  UserSession.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation

class UserSession {
    static let shared = UserSession()
    
    var userId: String?
    
    private init() {} 
}
