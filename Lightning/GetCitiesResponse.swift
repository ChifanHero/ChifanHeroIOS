//
//  GetCitiesResponse.swift
//  Lightning
//
//  Created by Shi Yan on 5/17/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetCitiesResponse: HttpResponseProtocol {

    var results: [City] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = City(data: resultJson)
                results.append(result)
            }
        }
        error = Error(data: data["error"])
    }

}
