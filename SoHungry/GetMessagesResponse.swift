//
//  GetMessagesResponse.swift
//  SoHungry
//
//  Created by Shi Yan on 9/1/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetMessagesResponse : Model {
    
    var results : [Message] = [Message]()
    var error : Error?
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        error <-- data["error"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Message(data: resultJson as! [String : AnyObject])
                results.append(result)
            }
        }
    }
}
