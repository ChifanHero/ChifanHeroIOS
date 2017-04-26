//
//  LightningColor.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class LightningColor {
    internal class func themeRed() -> UIColor {
        return UIColor(red: 235/255, green: 48/255, blue: 29/255, alpha: 1.0)
    }
    
    internal class func likeBackground() -> UIColor {
        //return UIColor(red: 235/255, green: 48/255, blue: 29/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Like_With_Background")!)
    }
    
    internal class func neutralOrange() -> UIColor {
        //return UIColor(red: 255/255, green: 113/255, blue: 36/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Neutral_With_Background")!)
    }
    
    internal class func negativeBlue() -> UIColor {
        //return UIColor(red: 54/255, green: 115/255, blue: 238/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Dislike_With_Background")!)
    }
    
    internal class func bookMarkYellow() -> UIColor {
        //return UIColor(red: 251/255, green: 242/255, blue: 0/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Bookmark_With_Background")!)
    }
    
    internal class func trashYellow() -> UIColor {
        //return UIColor(red: 251/255, green: 242/255, blue: 0/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Trash_With_Background")!)
    }
    
    internal class func themeRedLarge() -> UIColor {
        //return UIColor(red: 251/255, green: 242/255, blue: 0/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Like_With_Background_Large")!)
    }
    
    internal class func bookMarkGreenLarge() -> UIColor {
        //return UIColor(red: 251/255, green: 242/255, blue: 0/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Bookmark_With_Background_Large")!)
    }
    
    internal class func trashGreenLarge() -> UIColor {
        //return UIColor(red: 251/255, green: 242/255, blue: 0/255, alpha: 1.0)
        return UIColor(patternImage: UIImage(named: "Trash_With_Background_Large")!)
    }
}

extension UIColor {
    public class func themeOrange() -> UIColor {
        return UIColor(red: 254/255, green: 80/255, blue: 0/255, alpha: 1.0)
    }
    
    public class func chifanHeroGray() -> UIColor {
        return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
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
