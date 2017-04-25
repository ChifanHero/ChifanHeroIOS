//
//  CellActionTitle.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class CellActionTitle {
    
    //7 blank
    internal class func positive(_ count: Int) -> String {
        return "       \n\(count)"
    }
    
    internal class func neutral(_ count: Int) -> String {
        return "       \n\(count)"
    }
    
    internal class func negative(_ count: Int) -> String {
        return "       \n\(count)"
    }
    
    internal class func bookMark(_ count: Int) -> String {
        return "       \n\(count)"
    }
    
    //8 blank
    internal class func removeBookMark() -> String {
        return "        "
    }
}
