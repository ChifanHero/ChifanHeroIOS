//
//  ReviewResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/2/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReviewResponse: HttpResponseProtocol{
    
    var result: Review?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        result = Review(data: data["result"])
        error = Error(data: data["error"])
    }
}
