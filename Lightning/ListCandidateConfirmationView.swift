//
//  ListCandidateConfirmationView.swift
//  SoHungry
//
//  Created by Shi Yan on 11/1/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class ListCandidateConfirmationView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var view : UIView!
    private var nibName : String = "ListCandidateConfirmationView"
    var message : String? {
        didSet {
            messageLabel.text = message
        }
    }
    
    @IBOutlet weak var confirmButtonBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    var parentVC : UIViewController?
    
    var context : ListCandidateContext?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        UISetup()
    }
    
    func UISetup() {
        confirmButton.layer.cornerRadius = 5
        confirmButtonBottomConstraint.active = false
        self.layoutIfNeeded()
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func prepareToShow() {
        confirmButtonBottomConstraint.active = true
        self.layoutIfNeeded()
    }
    
    func prepareToHide() {
        confirmButtonBottomConstraint.active = false
        self.layoutIfNeeded()
    }

    @IBOutlet weak var confirmButton: UIButton!
    
  
    @IBAction func confirm(sender: AnyObject) {
        self.parentVC?.dismissViewControllerAnimated(true, completion: nil)
    }

}
