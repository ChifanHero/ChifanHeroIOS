//
//  GetReviewDetailRequest.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetReviewByIdRequest: HttpRequest{
    
    var resourceId : String
    
    init(id : String) {
        resourceId = id
    }
    
    func getResourceId() -> String {
        return resourceId
    }
    
    override func getRelativeURL() -> String {
        return "/reviews/" + resourceId
    }
}
