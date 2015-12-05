//
//  GetListsResponse.swift
//  Lightning
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetListsResponse : Model{
    
    var results: [List] = [List]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = List(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
}