//
//  LogOutResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/25/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class LogOutResponse: AccountResponse{
    
    required init() {
        super.init()
    }
    
    required init(data: [String : AnyObject]) {
        super.init()
        error <-- data["error"]
        success <-- data["success"]
    }
}