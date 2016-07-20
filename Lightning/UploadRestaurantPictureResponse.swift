//
//  UploadRestaurantPictureResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class UploadRestaurantPictureResponse: HttpResponseProtocol{
    
    var result: Picture?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
}