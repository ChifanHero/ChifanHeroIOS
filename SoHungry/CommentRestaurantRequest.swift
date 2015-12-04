//
//  CommentRestaurantRequest.swift
//  SoHungry
//
//  Created by Zhang, Alex on 12/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class CommentRestaurantRequest: PostRequestProtocol{
    
    var like: Bool?
    var dislike: Bool?
    var neutral: Bool?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, Bool>()
        parameters["like"] = like
        parameters["dislike"] = dislike
        parameters["neutral"] = neutral
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/users/update"
    }
}