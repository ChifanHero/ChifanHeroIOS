//
//  NominateRestaurantResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/25/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class NominateRestaurantResponse: HttpResponseProtocol{
    
    var result: Int?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]!["count"]
        error <-- data["error"]
    }
    
}