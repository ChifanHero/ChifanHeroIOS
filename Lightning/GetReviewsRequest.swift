//
//  GetReviewsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 11/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetReviewsRequest: HttpRequest{
    
    var limit: Int?
    var skip: Int?
    var restaurantId: String?
    var sort: String?
    
    override func getRelativeURL() -> String {
        return "/reviews"
    }
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if limit != nil {
            parameters["limit"] = String(limit!)
        }
        if skip != nil {
            parameters["offset"] = String(skip!)
        }
        if restaurantId != nil {
            parameters["restaurant_id"] = restaurantId
        }
        if skip != nil {
            parameters["sort"] = sort
        }
        return parameters
    }
}
