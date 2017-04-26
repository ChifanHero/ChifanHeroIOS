//
//  UploadPictureResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class UploadPictureResponse: HttpResponseProtocol{
    
    var result: Picture?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Picture(data: data["result"])
    }
}
