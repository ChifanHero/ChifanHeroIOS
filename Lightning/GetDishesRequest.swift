//
//  GetDishesRequest.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetDishesRequest: HttpRequestProtocol{
    
    func getRelativeURL() -> String {
        return ""
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
}