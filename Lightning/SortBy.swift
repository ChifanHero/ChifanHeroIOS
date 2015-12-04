//
//  SortBy.swift
//  SoHungry
//
//  Created by Shi Yan on 12/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

enum SortBy {
    
    case Hotness
    case Distance
    
    var description : String {
        switch self {
        case .Hotness : return "hotness"
        case .Distance : return "distance"
        }
    }
    
}
