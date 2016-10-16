//
//  ReviewRequest.swift
//  Lightning
//
//  Created by Shi Yan on 10/16/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class ReviewRequest: HttpRequest{
    
    var content: String?
    var userId: String?
    var rating: String?
    var restaurantId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["content"] = content
        parameters["user_id"] = userId
        parameters["rating"] = rating
        parameters["restaurant_id"] = restaurantId
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/reviews"
    }
}
