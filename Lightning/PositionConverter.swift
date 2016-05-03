//
//  PositionConverter.swift
//  Lightning
//
//  Created by Shi Yan on 4/30/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit

class PositionConverter {
    
    class func getViewAbsoluteFrame(aView : UIView) -> CGRect {
        let globalPoint = aView.superview?.convertPoint(aView.frame.origin, toView: nil)
        let aFrame = CGRectMake((globalPoint?.x)!, (globalPoint?.y)!, aView.frame.size.width, aView.frame.size.height)
        return aFrame
    }
    
}
