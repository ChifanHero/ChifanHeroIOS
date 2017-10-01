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
    
    func attributedStringFromHTML(_ size : CGFloat, highlightColor : UIColor?) -> NSAttributedString {
        var color = UIColor.black
        if highlightColor != nil {
            color = highlightColor!
        }
        let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: size) ]
        let attrString = NSMutableAttributedString(string: self, attributes: myAttribute)
        let boldFont = UIFont.boldSystemFont(ofSize: size)
        var r1 = (attrString.string as NSString).range(of: "<b>")
        while r1.location != NSNotFound {
            let r2 = (attrString.string as NSString).range(of: "</b>")
            if r2.location != NSNotFound  && r2.location > r1.location {
                let r3 = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length)
                attrString.addAttribute(NSFontAttributeName, value: boldFont, range: r3)
                attrString.addAttribute(NSForegroundColorAttributeName, value: color, range: r3)
                attrString.replaceCharacters(in: r2, with: "")
                attrString.replaceCharacters(in: r1, with: "")
            } else {
                break
            }
            r1 = (attrString.string as NSString).range(of: "<b>")
        }
        
        return attrString
    }
    
    func attributedStringFromHTML() -> NSAttributedString? {
        do {
            let data = self.data(using: String.Encoding.utf16, allowLossyConversion: true)
            if let d = data {
                let str: NSAttributedString = try NSAttributedString(data: d,options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
}
