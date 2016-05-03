//
//  GetSelectedCollectionsByLatAndLonResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/30/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetSelectedCollectionsByLatAndLonResponse: Model{
    
    var results: [SelectedCollection] = [SelectedCollection]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = SelectedCollection(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
        error <-- data["error"]
    }
    
}