//
//  RecommendDishRequest.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

//{
//    "restaurant_id" : "DC6UEqAWLA",
//    "dish_name" : "土豆丝",
//    "photos" : ["XIFMuc0trN", "4lxgoiNoyv"]
//}
class RecommendDishRequest: HttpRequest{
    
    var restaurantId: String?
    var dishName: String?
    var dishId: String?
    var photos: [String] = []
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["restaurant_id"] = restaurantId
        parameters["dish_name"] = dishName
        parameters["dish_id"] = dishId
        parameters["photos"] = photos
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/dishRecommendations"
    }
}
