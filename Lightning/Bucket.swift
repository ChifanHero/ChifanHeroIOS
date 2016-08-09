//
//  Bucket.swift
//  Lightning
//
//  Created by Shi Yan on 8/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class Bucket : Model{
    
    var results : [Restaurant] = [Restaurant]()
    var source : String?
    var label : String?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
        source <-- data["source"]
        label <-- data["label"]
    }
    
}
