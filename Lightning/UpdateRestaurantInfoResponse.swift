//
//  UpdateRestaurantInfoResponse.swift
//  Lightning
//
//  Created by Shi Yan on 4/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateRestaurantInfoResponse: HttpResponseProtocol{
    
    var result: Restaurant?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Restaurant(data: data["result"])
    }
    
}
