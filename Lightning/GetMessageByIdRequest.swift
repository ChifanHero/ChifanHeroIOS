//
//  GetMessageByIdRequest.swift
//  Lightning
//
//  Created by Shi Yan on 9/2/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetMessageByIdRequest : GetResourceRequestProtocol{
    
    var resourceId : String
    
    init(id : String) {
        resourceId = id
    }
    
    func getResourceId() -> String {
        return resourceId
    }
    
    func getRelativeURL() -> String {
        return "/messages"
    }
    
}
