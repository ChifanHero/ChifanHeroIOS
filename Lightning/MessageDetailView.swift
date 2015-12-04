//
//  MessageDetailView.swift
//  SoHungry
//
//  Created by Shi Yan on 9/2/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class MessageDetailView: UIView {

    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var view : UIView!
    private var nibName : String = "MessageDetail"
    
    
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
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setUpMessageView(source source : String, title : String, time : String, greetings : String, body : String, signature : String) {
        sourceLabel.text = source
        titleLabel.text = title
        timeLabel.text = time
        
        let fixedWidth = scrollView.frame.size.width - 32
        let font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        
        // add greetings label
        let greetingsLabel = UILabel()
        greetingsLabel.text = greetings
        greetingsLabel.font = font
        greetingsLabel.adjustsFontSizeToFitWidth = false
        greetingsLabel.frame = CGRectMake(16, 10, greetingsLabel.frame.size.width, greetingsLabel.frame.size.height)
        scrollView.addSubview(greetingsLabel)
        
        // add body label
        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.numberOfLines = 0
        bodyLabel.font = font
        bodyLabel.adjustsFontSizeToFitWidth = false
        let yBodyLabel = 10 + greetingsLabel.frame.size.height + 20
        let bodyLabelHeight = heightForText(body, font: font, width: fixedWidth, lineBreakMode: NSLineBreakMode.ByWordWrapping)
        bodyLabel.frame = CGRectMake(16, yBodyLabel, fixedWidth, bodyLabelHeight)
        scrollView.addSubview(bodyLabel)
        
        // add signature label
        let signatureLabel = UILabel()
        signatureLabel.text = signature
        signatureLabel.font = font
        signatureLabel.adjustsFontSizeToFitWidth = false
        let ySignatureLabel = yBodyLabel + bodyLabelHeight + 20
        signatureLabel.frame = CGRectMake(216, ySignatureLabel, signatureLabel.frame.size.width, signatureLabel.frame.size.height)
        scrollView.addSubview(signatureLabel)
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, ySignatureLabel + signatureLabel.frame.size.height + 10)
    }
    
    private func heightForText(text : String, font : UIFont, width : CGFloat, lineBreakMode : NSLineBreakMode) -> CGFloat {
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        let drawingOptions : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.UsesFontLeading)
        let size : CGSize = (text as NSString).boundingRectWithSize(CGSizeMake(width, CGFloat.max), options:drawingOptions, attributes: [NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle], context: nil).size
        return size.height
    }

}
