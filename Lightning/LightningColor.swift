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
