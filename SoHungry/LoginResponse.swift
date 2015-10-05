//
//  LoginResponse.swift
//  SoHungry
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class LoginResponse: Model {
    
    var success : Bool?
    var sessionToken : String?
    var user : User?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        success <-- data["success"]
        sessionToken <-- data["session_token"]
        user <-- data["user"]
    }
    
}
