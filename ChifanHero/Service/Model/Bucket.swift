//
//  Bucket.swift
//  Lightning
//
//  Created by Shi Yan on 8/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class Bucket : Model{
    
    var results : [Restaurant] = [Restaurant]()
    var source : String?
    var label : String?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                results.append(result)
            }
        }
        source = data["source"].string
        label = data["label"].string
    }
    
}
