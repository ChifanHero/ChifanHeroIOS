//
//  GetFavoritesResponse.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/13/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetFavoritesResponse: Model{
    
    var error: Error?
    var results: [Favorite] = [Favorite]()
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Favorite(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
}