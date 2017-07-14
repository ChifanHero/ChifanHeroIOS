//
//  LightningColor.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

extension UIColor {
    public class func themeOrange() -> UIColor {
        return UIColor(red: 254/255, green: 80/255, blue: 0/255, alpha: 1.0)
    }
    
    public class func chifanHeroGray() -> UIColor {
        return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    public class func chifanHeroGreen() -> UIColor {
        return UIColor(red: 60/255, green: 160/255, blue: 30/255, alpha: 1.0)
    }
    
    public class func chifanHeroBlue() -> UIColor {
        return UIColor(red: 70/255, green: 120/255, blue: 240/255, alpha: 1.0)
    }
    
    public class func chifanHeroRed() -> UIColor {
        return UIColor(red: 255/255, green: 40/255, blue: 40/255, alpha: 1.0)
    }
}

extension UIColor {
    
    func getColorCode() -> UInt {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        let colorAsUInt : UInt = 0xFFFFFF
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            var colorAsUInt : UInt32 = 0
            
            colorAsUInt += UInt32(red * 255.0) << 16 +
                UInt32(green * 255.0) << 8 +
                UInt32(blue * 255.0)
        }
        return colorAsUInt
    }
    
}
