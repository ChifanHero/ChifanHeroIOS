//
//  UpdateInfoRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UpdateInfoRequest: HttpRequest{
    
    var nickName: String?
    var pictureId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["nick_name"] = nickName
        parameters["pictureId"] = pictureId
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/users/update"
    }
}