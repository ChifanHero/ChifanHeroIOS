//
//  UpdateInfoRequest.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class UpdateInfoRequest: PostRequestProtocol{
    
    var nickName: String?
    var pictureId: String?
    
    func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["nick_name"] = nickName
        parameters["pictureId"] = pictureId
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/users/update"
    }
}