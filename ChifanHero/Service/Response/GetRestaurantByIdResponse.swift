//
//  GetRestaurantByIdResponse.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetRestaurantByIdResponse: HttpResponseProtocol{
    
    var result: Restaurant?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Restaurant(data: data["result"])
    }
    
}
