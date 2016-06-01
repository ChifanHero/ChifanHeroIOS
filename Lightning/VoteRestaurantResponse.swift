//
//  VoteRestaurantResponse.swift
//  Lightning
//
//  Created by Shi Yan on 1/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class VoteRestaurantResponse: HttpResponseProtocol{
    
    var result: RestaurantCandidate?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]
        error <-- data["error"]
    }
}
