//
//  ReviewRequest.swift
//  Lightning
//
//  Created by Shi Yan on 10/16/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation


//{
    // 	"rating" : 5,
    // 	"content" : "this is a good restaurant",
    // 	"photos" : ["s8gh3ksg2d", "s8gi4hsgs7"],
    // 	"id" : "9wigjh2d8u",
    //
class ReviewRequest: HttpRequest{
    
    var content: String?
    var rating: Int?
    var restaurantId: String?
    var photos: [String]?
    var id: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["content"] = content as AnyObject
        parameters["rating"] = rating as AnyObject
        parameters["restaurant_id"] = restaurantId as AnyObject
        parameters["id"] = id as AnyObject
        parameters["photos"] = photos as AnyObject
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/reviews"
    }
}
