//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Ali Atakan AKMAN on 14.10.2020.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
    
    
    
}
