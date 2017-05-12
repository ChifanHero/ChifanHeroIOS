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
    var rating: Int?
    var restaurantId: String?
    var photos: [String]?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["content"] = content as AnyObject
        parameters["rating"] = rating as AnyObject
        parameters["restaurant_id"] = restaurantId as AnyObject
        parameters["photos"] = photos as AnyObject
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/reviews"
    }
}
