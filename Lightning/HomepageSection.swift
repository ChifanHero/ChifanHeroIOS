//
//  HomepageSection.swift
//  Lightning
//
//  Created by Zhang, Alex on 8/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class HomepageSection: Model{
    
    var title: String?
    var placement: Int?
    var restaurants: [Restaurant] = [Restaurant]()
    
    required init() {
        
    }
    
    required init(data: [String : AnyObject]) {
        title <-- data["title"]
        placement <-- data["placement"]
        if let resultsJson = data["results"] as? [AnyObject] {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson as! [String : AnyObject])
                restaurants.append(result)
            }
        }
    }
}