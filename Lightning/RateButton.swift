//
//  RateButton.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

@IBDesignable class RateButton: UIButton {
    
    var rated : Bool = false
    
    @IBInspectable var unselectedColor : UIColor = UIColor.lightGrayColor() {
        didSet {
            backgroundColor = unselectedColor
        }
    }
    @IBInspectable var selectedColor : UIColor = UIColor.themeOrange()
    
    func rate(handler : (()->Void)) {
        rated = true
        self.backgroundColor = self.selectedColor
        handler()
//        UIView.animateWithDuration(0.2, animations: {
//            self.alpha = 0
//        }) { (done) in
//            self.backgroundColor = self.selectedColor
//            UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
//                self.alpha = 1
//                }, completion:  { (complete) in
//                    handler()
//            })
//            
//        }
    }
    
    func unRate(handler : (()->Void)) {
        rated = false
        self.backgroundColor = self.unselectedColor
        handler()
//        UIView.animateWithDuration(0.2, animations: {
//            self.alpha = 0
//        }) { (done) in
//            self.backgroundColor = self.unselectedColor
//            UIView.animateWithDuration(0.2, delay: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
//                self.alpha = 1
//                }, completion: nil)
//        }
    }
}
