//
//  DishRecommendation.swift
//  Lightning
//
//  Created by Shi Yan on 11/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class DishRecommendation: Model{
    
    var dish: Dish?

    
    required init() {
        
    }
    
    required init(data: JSON) {
        dish = Dish(data: data["dish"])
    }
    
    
}
