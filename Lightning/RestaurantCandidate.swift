//
//  RestaurantCandidate.swift
//  Lightning
//
//  Created by Shi Yan on 1/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class RestaurantCandidate : Model{
    
    var id : String?
    var votes : Int?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        id <-- data["id"]
        votes <-- data["votes"]
    }
}