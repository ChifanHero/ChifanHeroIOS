//
//  GetPromotionsResponse.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetPromotionsResponse: HttpResponseProtocol {
    
    var results: [Promotion] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Promotion(data: resultJson)
                results.append(result)
            }
        }
    }
    
}
