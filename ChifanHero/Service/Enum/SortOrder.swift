//
//  SortOrder.swift
//  Lightning
//
//  Created by Shi Yan on 8/20/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

enum SortOrder {
    
    case ascend
    case descend
    
    var description : String {
        switch self {
        case .ascend : return "ascend"
        case .descend : return "descend"
        }
    }
    
}
