//
//  RemoveFavoriteRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 2/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class RemoveFavoriteRequest: HttpRequest{
    
    var type: String?
    var objectId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["type"] = type
        parameters["object_id"] = objectId
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/favorites"
    }
}