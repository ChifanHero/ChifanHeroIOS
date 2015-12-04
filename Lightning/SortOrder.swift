//
//  SortOrder.swift
//  SoHungry
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

enum SortOrder {
    
    case Increase
    case Decrease
    
    var description : String {
        switch self {
        case .Increase : return "increase"
        case .Decrease : return "decrease"
        }
    }
    
}
