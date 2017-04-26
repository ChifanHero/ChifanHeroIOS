//
//  RemoveFavoriteResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 2/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class RemoveFavoriteResponse: HttpResponseProtocol{
    
    var result: Favorite?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        result = Favorite(data: data["result"])
        error = Error(data: data["error"])
    }
}
