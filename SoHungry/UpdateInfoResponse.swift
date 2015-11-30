//
//  UpdateInfoResponse.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class UpdateInfoResponse: Model{
    
    var success: Bool?
    var user: User?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        user <-- data["user"]
        success <-- data["success"]
    }
}