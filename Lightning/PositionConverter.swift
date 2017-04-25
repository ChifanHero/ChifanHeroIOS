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
    
    class func getViewAbsoluteFrame(_ aView : UIView) -> CGRect {
        let globalPoint = aView.superview?.convert(aView.frame.origin, to: nil)
        let aFrame = CGRect(x: (globalPoint?.x)!, y: (globalPoint?.y)!, width: aView.frame.size.width, height: aView.frame.size.height)
        return aFrame
    }
    
}
