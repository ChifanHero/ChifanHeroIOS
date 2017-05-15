//
//  UploadPictureRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UploadPictureRequest: HttpRequest{
    
    var restaurantId: String?
    var reviewId: String?
    var base64_code: String
    
    init(base64_code: String){
        self.base64_code = base64_code
    }
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        if restaurantId != nil {
            parameters["restaurant_id"] = restaurantId
        }
        if reviewId != nil {
            parameters["review_id"] = reviewId
        }
        parameters["base64_code"] = base64_code
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/images"
    }
}
