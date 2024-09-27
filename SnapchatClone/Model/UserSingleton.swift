//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Beyza Nur Tekerek on 27.09.2024.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
