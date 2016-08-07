//
//  SortOrder.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


enum SortParameter : CustomStringConvertible{
    
    case Hotness
    case Distance
    case Rating
    
    var description : String {
        switch self {
        case .Hotness : return "hotness"
        case .Distance : return "distance"
        case .Rating : return "rating"
        }
    }
    
}