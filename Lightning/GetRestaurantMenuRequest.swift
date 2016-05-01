//
//  GetRestaurantMenuRequest.swift
//  Lightning
//
//  Created by Shi Yan on 9/8/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
class GetRestaurantMenuRequest : GetRequestProtocol{
    
    var restaurantId : String
    
    init(restaurantId : String) {
        self.restaurantId = restaurantId
    }
    
    func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId + "/menus"
    }
}
