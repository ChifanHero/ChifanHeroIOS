//
//  UploadPictureRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UploadPictureRequest: HttpRequest{
    
    var base64_code: String
    var eventId: String?
    
    init(base64_code: String){
        self.base64_code = base64_code
    }
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["base64_code"] = base64_code
        parameters["event_id"] = eventId
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/images"
    }
}
