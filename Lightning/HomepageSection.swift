//
//  HomepageSection.swift
//  Lightning
//
//  Created by Zhang, Alex on 8/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomepageSection: Model{
    
    var title: String?
    var placement: Int?
    var restaurants: [Restaurant] = [Restaurant]()
    
    required init() {
        
    }
    
    required init(data: JSON) {
        title = data["title"].string
        placement = data["placement"].int
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                restaurants.append(result)
            }
        }
    }
}
