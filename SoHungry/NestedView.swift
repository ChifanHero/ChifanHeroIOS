//
//  NestedView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/13/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

protocol AnimatedNestedView {
    
    func getSubview() -> UIView
    
    func getSubviewStartFrame() -> CGRect
    
    func getSubviewEndFrame() -> CGRect
    
    func subviewTransitionDidEnd() 
    
}

extension AnimatedNestedView {
    
}
