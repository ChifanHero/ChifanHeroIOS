//
//  StringExtension.swift
//  Lightning
//
//  Created by Shi Yan on 3/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func attributedStringFromHTML(size : CGFloat, highlightColor : UIColor?) -> NSAttributedString {
        var color = UIColor.blackColor()
        if highlightColor != nil {
            color = highlightColor!
        }
        let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(size) ]
        let attrString = NSMutableAttributedString(string: self, attributes: myAttribute)
//        let boldFont = UIFont(name: "Helvetica-Bold", size: 14.0)!
        let boldFont = UIFont.boldSystemFontOfSize(size)
        var r1 = (attrString.string as NSString).rangeOfString("<b>")
        while r1.location != NSNotFound {
            let r2 = (attrString.string as NSString).rangeOfString("</b>")
            if r2.location != NSNotFound  && r2.location > r1.location {
                let r3 = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length)
                attrString.addAttribute(NSFontAttributeName, value: boldFont, range: r3)
                attrString.addAttribute(NSForegroundColorAttributeName, value: color, range: r3)
                attrString.replaceCharactersInRange(r2, withString: "")
                attrString.replaceCharactersInRange(r1, withString: "")
            } else {
                break
            }
            r1 = (attrString.string as NSString).rangeOfString("<b>")
        }
        
        return attrString
    }
    
}
