//
//  GetRestaurantByIdResponse.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetRestaurantByIdResponse : Model{
    
    var result: Restaurant?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
    
}
