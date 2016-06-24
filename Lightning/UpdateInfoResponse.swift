//
//  UpdateInfoResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UpdateInfoResponse: AccountResponse{
    
    required init() {
        super.init()
    }
    
    required init(data: [String : AnyObject]) {
        super.init(data: data)
        error <-- data["error"]
        user <-- data["user"]
        success <-- data["success"]
    }
}