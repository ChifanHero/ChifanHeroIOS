//
//  GetSelectedCollectionsByLatAndLonResponse.swift
//  Lightning
//
//  Created by Zhang, Alex on 4/30/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetSelectedCollectionsByLatAndLonResponse: Model{
    
    var result: SelectedCollection?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        result <-- data["result"]
        error <-- data["error"]
    }
    
}