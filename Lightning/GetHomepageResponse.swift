//
//  GetHomepageResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 8/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetHomepageResponse: HttpResponseProtocol {
    
    var results: [HomepageSection] = [HomepageSection]()
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["homepagesections"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = HomepageSection(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
    
}