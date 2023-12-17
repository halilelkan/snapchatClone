//
//  userSingleton.swift
//  snapchatClone
//
//  Created by halil ibrahim Elkan on 8.07.2023.
//

import Foundation

class userSingleton {
    
    static let sharedUserInfo = userSingleton()
    
    var email = ""
    var userName = ""
    
    private init(){
        
    }
}
