//
//  SignUpResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/3/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class SignUpResponse: AccountResponse {
    
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        success = data["success"].bool
        sessionToken = data["session_token"].string
        user = User(data: data["user"])
        error = Error(data: data["error"])
    }
    
}
