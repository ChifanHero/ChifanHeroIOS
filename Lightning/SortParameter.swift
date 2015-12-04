//
//  SortOrder.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation


enum SortParameter : CustomStringConvertible{
    
    case Hotness
    case Distance
    
    var description : String {
        switch self {
        case .Hotness : return "hotness"
        case .Distance : return "distance"
        }
    }
    
}