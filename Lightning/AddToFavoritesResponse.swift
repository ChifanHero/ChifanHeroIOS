//
//  AddToFavoritesResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/7/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class AddToFavoritesResponse: Model{
    
    var result: Favorite?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]
        error <-- data["error"]
    }
}