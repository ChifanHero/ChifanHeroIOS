//
//  CellActionTitle.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class CellActionTitle {
    internal class func positive(count: Int) -> String {
        return "\u{1F44D}\n\(count)"
    }
    
    internal class func neutral(count: Int) -> String {
        return "\u{1F44C}\n\(count)"
    }
    
    internal class func negative(count: Int) -> String {
        return "\u{1F44E}\n\(count)"
    }
    
    internal class func bookMark(count: Int) -> String {
        return "\u{1F4E5}\n\(count)"
    }
    
    internal class func removeBookMark() -> String {
        return "\u{1F4E4}"
    }
}
