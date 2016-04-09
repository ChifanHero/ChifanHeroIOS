//
//  UpdateRestaurantInfoResponse.swift
//  Lightning
//
//  Created by Shi Yan on 4/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class UpdateRestaurantInfoResponse : Model{
    
    var result: Restaurant?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
    
}