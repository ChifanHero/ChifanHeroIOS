//
//  DistanceUnit.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

enum DistanceUnit {
    
    case MILE
    case KM
    
    var description : String {
        switch self {
        case .MILE : return "mi"
        case .KM : return "km"
        }
    }
    
}


