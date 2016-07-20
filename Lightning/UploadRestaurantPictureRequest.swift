//
//  UploadRestaurantPictureRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class UploadRestaurantPictureRequest: HttpRequest{
    
    var restaurantId: String
    var type: String
    var base64_code: String
    
    init(restaurantId: String, type: String, base64_code: String){
        self.restaurantId = restaurantId
        self.type = type
        self.base64_code = base64_code
    }
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["restaurant_id"] = restaurantId
        parameters["type"] = type
        parameters["base64_code"] = base64_code
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/images"
    }
}