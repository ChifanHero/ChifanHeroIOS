//
//  GetRestaurantMenuRequest.swift
//  SoHungry
//
//  Created by Shi Yan on 9/8/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation
class GetRestaurantMenuRequest : GetRequestProtocol{
    
    var restaurantId : String
    
    init(restaurantId : String) {
        self.restaurantId = restaurantId
    }
    
    func getParameters() -> [String:String] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId + "/menu"
    }
}
