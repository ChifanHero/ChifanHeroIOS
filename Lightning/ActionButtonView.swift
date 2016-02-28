//
//  ActionButtonView.swift
//  Lightning
//
//  Created by Shi Yan on 1/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

@IBDesignable class ActionButtonView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "ActionButtonView"
    

    @IBInspectable var icon : UIImage? {
        didSet {
            actionIcon.image = icon
        }
    }
    
    @IBInspectable var actionCount : Int? {
        didSet {
            if actionCount == nil {
                actionCount = 0
            }
            actionCountLabel.text = "\(actionCount!)"
        }
    }
    
    
    @IBInspectable var backgroundColour : UIColor? {
        didSet {
//            self.backgroundColor = backgroundColour
            self.containerView.backgroundColor = backgroundColour
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var actionIcon: UIImageView!
    
    @IBOutlet weak var actionCountLabel: UILabel!
    
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

}
