//
//  GetHomepageResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 8/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetHomepageResponse: HttpResponseProtocol {
    
    var results: [HomepageSection] = []
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["homepagesections"].array {
            for resultJson in resultsJson {
                let result = HomepageSection(data: resultJson)
                results.append(result)
            }
        }
    }
    
}
