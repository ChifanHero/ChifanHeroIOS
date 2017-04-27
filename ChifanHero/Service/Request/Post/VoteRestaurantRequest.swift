//
//  VoteRestaurantRequest.swift
//  Lightning
//
//  Created by Shi Yan on 1/22/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class VoteRestaurantRequest: HttpRequest{
    
    var restaurantId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["restaurant_id"] = restaurantId
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/restaurantCandidates"
    }
}
