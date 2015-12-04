//
//  LogOutResponse.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/25/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class LogOutResponse: Model{
    
    var success: Bool?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        success <-- data["success"]
    }
}