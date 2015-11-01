//
//  ListCandidateSubView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/14/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class ListCandidateSubView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "ListCandidateSubView"
    
    @IBOutlet weak var subView: ListCandidateConfirmationView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var confirmButton: UIButton!
    var contentViewCollapsed = false
    
    var submitButton : UIButton {
        return self.subView.confirmButton
    }
    
    var subViewTopToHeaderViewBottom : NSLayoutConstraint!
    
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
    
    private func UISetup() {
        subViewTopToHeaderViewBottom = NSLayoutConstraint(item: self.subView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.headerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        subViewTopToHeaderViewBottom.priority = 1000
        subViewTopToHeaderViewBottom.active = false
        subView.layer.cornerRadius = 15
        subView.layer.borderWidth = 1.5
        subView.layer.borderColor = UIColor.lightGrayColor().CGColor
        confirmButton.layer.cornerRadius = 5
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    
    @IBAction func confirm(sender: AnyObject) {
        self.subViewTopToHeaderViewBottom.active = true
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (success) -> Void in
                self.contentViewCollapsed = true
        }
    }

    @IBAction func headerViewTapped(sender: AnyObject) {
        if contentViewCollapsed {
            self.subViewTopToHeaderViewBottom.active = false
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }) { (success) -> Void in
                    self.contentViewCollapsed = false
            }
        }
    }
}
