//
//  GetDishesRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetDishesRequest : GetRequestProtocol{
    
    func getParameters() -> [String:String] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
    func getRelativeURL() -> String {
        return ""
    }
    
}