//
//  UpdateRestaurantInfoRequest.swift
//  Lightning
//
//  Created by Shi Yan on 4/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class UpdateRestaurantInfoRequest: HttpRequest{
    
    var restaurantId: String?
    var imageId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["image_id"] = imageId
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId!
    }
}
