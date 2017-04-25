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
    
    var delegate : SelectionBarDelegate?
    
    @IBInspectable var boarderColor : UIColor? {
        didSet {
            for button in buttons {
                button.layer.borderColor = boarderColor?.cgColor
            }
        }
    }
    
    fileprivate var view : UIView!
    fileprivate var nibName : String = "SelectionBar"
    
    var scope : String = "restaurant"
    
    var previousScope : String = ""
    
    
    @IBOutlet var buttons: [UIButton]!
    
    
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
        UISetup()
    }
    
    fileprivate func LoadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    fileprivate func UISetup() {
        for button in buttons {
           button.layer.borderColor = boarderColor?.cgColor
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0
        }
        buttons[0].layer.borderWidth = 1
    }

    @IBAction func restaurantButtonClicked(_ sender: AnyObject) {
        previousScope = scope
        scope = "restaurant"
        toggleButtonStatus(sender)
        delegate?.restaurantButtonClicked()
    }

    @IBAction func dishButtonPressed(_ sender: AnyObject) {
        previousScope = scope
        scope = "dish"
        toggleButtonStatus(sender)
        delegate?.dishButtonPressed()
    }
    
    
    @IBAction func listButtonPressed(_ sender: AnyObject) {
        previousScope = scope
        scope = "list"
        toggleButtonStatus(sender)
        delegate?.listButtonPressed()
    }
    
    fileprivate func toggleButtonStatus(_ sender: AnyObject) {
        let button : UIButton = sender as! UIButton
        for button in buttons {
            button.layer.borderWidth = 0
        }
        button.layer.borderWidth = 1
    }
    
}
