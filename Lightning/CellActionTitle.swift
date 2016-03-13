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
    internal class func positive(count: Int) -> String {
        return "       \n\(count)"
    }
    
    internal class func neutral(count: Int) -> String {
        return "       \n\(count)"
    }
    
    internal class func negative(count: Int) -> String {
        return "       \n\(count)"
    }
    
    internal class func bookMark(count: Int) -> String {
        return "       \n\(count)"
    }
    
    //8 blank
    internal class func removeBookMark() -> String {
        return "        "
    }
}
