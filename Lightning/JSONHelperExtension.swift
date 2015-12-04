//
//  JSONHelperExtension.swift
//  Lightning
//
//  Created by Shi Yan on 8/16/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation


/// Returns nil if given object is of type NSNull.
///
/// :param: object Object to convert.
///
/// :returns: nil if object is of type NSNull, else returns the object itself.
private func convertToNilIfNull(object: AnyObject?) -> AnyObject? {
    if object is NSNull {
        return nil
    }
    return object
}

func <-- <T: Model>(inout property: T?, dataObject: AnyObject?) -> T? {
    if let data = dataObject as? [String : AnyObject] {
        property = T(data: data)
    } else {
        property = nil
    }
    return property
}

func <-- (inout property: NSDate?, dataObject: AnyObject?) -> NSDate? {
    if let date = dataObject as? String {
        property = NSDate(dateString: date)
    } else {
       property = nil
    }
    return property
}






