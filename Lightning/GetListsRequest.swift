//
//  GetListsRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetListsRequest : GetRequestProtocol {
    
    var limit : Int?
    var skip : Int?
    
    func getParameters() -> [String:String] {
        var parameters = Dictionary<String, String>()
        if limit != nil {
            parameters["limit"] = String(limit!)
        }
        if skip != nil {
            parameters["skip"] = String(skip!)
        }
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/lists"
    }
    
}