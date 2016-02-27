//
//  NominateDishListCandidateResponse.swift
//  Lightning
//
//  Created by Shi Yan on 2/27/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class NominateDishListCandidateResponse : Model{
    
    var result: DishListCandiate?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]
        error <-- data["error"]
    }
    
}
