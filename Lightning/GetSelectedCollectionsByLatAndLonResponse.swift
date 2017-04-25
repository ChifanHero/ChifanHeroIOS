//
//  GetSelectedCollectionsByLatAndLonResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/30/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetSelectedCollectionsByLatAndLonResponse: HttpResponseProtocol{
    
    var results: [SelectedCollection] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = SelectedCollection(data: resultJson)
                results.append(result)
            }
        }
        error = Error(data: data["error"])
    }
    
}
