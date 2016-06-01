//
//  UploadPictureResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class UploadPictureResponse: HttpResponseProtocol{
    
    var result: Picture?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
}