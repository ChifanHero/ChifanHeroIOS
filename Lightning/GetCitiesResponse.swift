//
//  GetCitiesResponse.swift
//  Lightning
//
//  Created by Shi Yan on 5/17/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetCitiesResponse : Model {

    var results: [City] = [City]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = City(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
        error <-- data["error"]
    }

}
