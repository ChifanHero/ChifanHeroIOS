//
//  NominateDishListCandidateRequest.swift
//  Lightning
//
//  Created by Shi Yan on 2/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class NominateDishListCandidateRequest: HttpRequest{
    
    var dishId : String?
    var listId : String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["dish_id"] = dishId
        parameters["list_id"] = listId
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/lists/candidates"
    }
    
}
