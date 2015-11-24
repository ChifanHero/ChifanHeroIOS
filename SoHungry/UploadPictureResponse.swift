//
//  UploadPictureResponse.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/23/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class UploadPictureResponse: Model{
    
    var result: Picture?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        result <-- data["result"]
    }
}