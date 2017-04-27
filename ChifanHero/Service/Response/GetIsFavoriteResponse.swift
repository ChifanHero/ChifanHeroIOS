//
//  GetIsFavoriteResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetIsFavoriteResponse: HttpResponseProtocol{
    var error: Error?
    var result: Bool?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        result = data["result"].bool
    }
}
