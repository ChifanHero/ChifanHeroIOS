//
//  LoginResponse.swift
//  Lightning
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class LoginResponse: AccountResponse {
    
    required init() {
        super.init()
    }
    
    required init(data: [String : AnyObject]) {
        super.init(data: data)
        self.success <-- data["success"]
        self.sessionToken <-- data["session_token"]
        self.user <-- data["user"]
    }
}
