//
//  MessageDetailView.swift
//  SoHungry
//
//  Created by Shi Yan on 9/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class NotificationDetailView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!

    
    private var view : UIView!
    private var nibName : String = "NotificationDetailView"
    
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setUp(title : String, body : String) {
        titleLabel.text = title
        do {
            let bodyWithFormat = NSString(format:"<span style=\"font-size: 15\">%@</span>", body) as String
            let attributedBody = try NSMutableAttributedString(data: bodyWithFormat.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.bodyTextView.attributedText = attributedBody
        } catch {
            
        }

    }
    
//    private func heightForText(text : String, font : UIFont, width : CGFloat, lineBreakMode : NSLineBreakMode) -> CGFloat {
//        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineBreakMode = lineBreakMode
//        let drawingOptions : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.UsesFontLeading)
//        let size : CGSize = (text as NSString).boundingRectWithSize(CGSizeMake(width, CGFloat.max), options:drawingOptions, attributes: [NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle], context: nil).size
//        return size.height
//    }

}
