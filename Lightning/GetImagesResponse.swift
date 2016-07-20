//
//  GetImagesResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/20/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetImagesResponse: HttpResponseProtocol {
    
    var results: [Picture] = [Picture]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
    
}