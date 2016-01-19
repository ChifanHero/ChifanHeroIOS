//
//  SortOrder.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

enum SortOrder {
    
    case Ascend
    case Descend
    
    var description : String {
        switch self {
        case .Ascend : return "ascend"
        case .Descend : return "descend"
        }
    }
    
}
