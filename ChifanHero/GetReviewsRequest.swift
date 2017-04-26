//
//  GetReviewsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 11/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetReviewsRequest: HttpRequest{
    
    var limit: Int = 50
    var skip: Int = 0
    var restaurantId: String?
    var sort: String = "quality"
    
    override func getRelativeURL() -> String {
        return "/reviews?restaurant_id=\(restaurantId!)&limit=\(limit)&skip=\(skip)&sort=\(sort)"
    }
    
}
