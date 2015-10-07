//
//  SelectionPanelView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/6/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class SelectionBar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var boarderColor : UIColor? {
        didSet {
            for button in buttons {
                button.layer.borderColor = boarderColor?.CGColor
            }
        }
    }
    
    private var view : UIView!
    private var nibName : String = "SelectionBar"
    
    
    @IBOutlet var buttons: [UIButton]!
    
    
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
        UISetup()
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    private func UISetup() {
        for button in buttons {
           button.layer.borderColor = boarderColor?.CGColor
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0
        }
        buttons[0].layer.borderWidth = 1
    }

    @IBAction func restaurantButtonClicked(sender: AnyObject) {
        toggleButtonStatus(sender)
    }

    @IBAction func dishButtonPressed(sender: AnyObject) {
        toggleButtonStatus(sender)
    }
    
    
    @IBAction func listButtonPressed(sender: AnyObject) {
        toggleButtonStatus(sender)
    }
    
    private func toggleButtonStatus(sender: AnyObject) {
        let button : UIButton = sender as! UIButton
        for button in buttons {
            button.layer.borderWidth = 0
        }
        button.layer.borderWidth = 1
    }
    
}
