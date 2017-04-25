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
    
    fileprivate var view : UIView!
    fileprivate var nibName : String = "ActionButtonView"
    

    @IBInspectable var icon : UIImage? {
        didSet {
            actionIcon.image = icon
        }
    }
    
    @IBInspectable var actionCount : Int = 0 {
        didSet {
            actionCountLabel.text = "\(actionCount)"
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
    
    fileprivate func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    }
    
    fileprivate func LoadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
