//
//  DistanceUnit.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

enum DistanceUnit {
    
    case mile
    case km
    
    var description : String {
        switch self {
        case .mile : return "mi"
        case .km : return "km"
        }
    }
    
}


