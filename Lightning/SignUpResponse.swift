//
//  SignUpResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/3/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class SignUpResponse: AccountResponse {
    
    required init() {
        super.init()
    }
    
    required init(data: [String : AnyObject]) {
        super.init(data: data)
        success <-- data["success"]
        sessionToken <-- data["session_token"]
        user <-- data["user"]
        error <-- data["error"]
    }
    
}