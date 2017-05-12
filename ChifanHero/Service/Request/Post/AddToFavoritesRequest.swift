//
//  AddToFavoritesRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/7/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class AddToFavoritesRequest: HttpRequest{
    
    var type: String?
    var objectId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["type"] = type
        parameters["object_id"] = objectId
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/favorites"
    }
}
