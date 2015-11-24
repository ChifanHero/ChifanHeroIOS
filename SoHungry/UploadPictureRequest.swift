//
//  UploadPictureRequest.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class UploadPictureRequest: PostRequestProtocol{
    
    var base64_code: String
    
    init(base64_code: String){
        self.base64_code = base64_code
    }
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["base64_code"] = base64_code
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/images"
    }
}