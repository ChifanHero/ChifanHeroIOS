//
//  SignUpResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/3/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class SignUpResponse: Model {
    
    var success: Bool?
    var sessionToken: String?
    var user: User?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        success <-- data["success"]
        sessionToken <-- data["session_token"]
        user <-- data["user"]
        error <-- data["error"]
    }
    
}