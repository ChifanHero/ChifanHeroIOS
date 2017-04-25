//
//  GetImagesResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/20/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetImagesResponse: HttpResponseProtocol {
    
    var results: [Picture] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson)
                results.append(result)
            }
        }
    }
    
}
