//
//  GetFavoritesResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/13/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetFavoritesResponse: HttpResponseProtocol{
    
    var error: Error?
    var results: [Favorite] = []
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Favorite(data: resultJson)
                results.append(result)
            }
        }
    }
}
