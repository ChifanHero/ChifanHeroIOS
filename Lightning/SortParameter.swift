//
//  SortOrder.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


enum SortParameter : CustomStringConvertible{
    
    case hotness
    case distance
    case rating
    
    var description : String {
        switch self {
        case .hotness : return "hotness"
        case .distance : return "distance"
        case .rating : return "rating"
        }
    }
    
}
