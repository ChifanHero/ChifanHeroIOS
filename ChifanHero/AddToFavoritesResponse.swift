//
//  AddToFavoritesResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/7/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddToFavoritesResponse: HttpResponseProtocol{
    
    var result: Favorite?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        result = Favorite(data: data["result"])
        error = Error(data: data["error"])
    }
}
