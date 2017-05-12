//
//  GetReviewByIdResponse.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetReviewByIdResponse: HttpResponseProtocol{
    
    var result: Review?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Review(data: data["result"])
    }
    
}
