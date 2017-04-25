//
//  NominateRestaurantResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/25/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class NominateRestaurantResponse: HttpResponseProtocol{
    
    var result: Int?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        result = data["result"]["count"].int
        error = Error(data: data["error"])
    }
    
}
