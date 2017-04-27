//
//  UIColor+FloatingMenu.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/19/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

extension UIColor {
    class func flatWhiteColor() -> UIColor {
        return UIColor(red: 0.9274, green: 0.9436, blue: 0.95, alpha: 1.0)
    }
    
    class func flatBlackColor() -> UIColor {
        return UIColor(red: 0.1674, green: 0.1674, blue: 0.1674, alpha: 1.0)
    }
    
    class func flatBlueColor() -> UIColor {
        return UIColor(red: 0.3132, green: 0.3974, blue: 0.6365, alpha: 1.0)
    }
    
    class func flatRedColor() -> UIColor {
        return UIColor(red: 0.9115, green: 0.2994, blue: 0.2335, alpha: 1.0)
    }
    
    var pixelImage: UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        self.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
