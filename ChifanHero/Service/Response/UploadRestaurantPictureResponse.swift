//
//  UploadRestaurantPictureResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class UploadRestaurantPictureResponse: HttpResponseProtocol{
    
    var result: Picture?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Picture(data: data["result"])
    }
}
