//
//  SlideBar.swift
//  HorizontalScroll
//
//  Created by Shi Yan on 8/25/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SlideBar: UIView {
    
    
    var view: UIView!
    private var nibName: String  = "SlideBar"
    @IBOutlet weak var selectionBox: UIView!
    
//    private var selectionBox : UIView = UIView()
    
    private var barElements : [UIView] = []
    
    var delegate: SlideBarDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBInspectable var scrollBackgroundColor : UIColor? {
        get {
            return scrollView.backgroundColor
        }
        
        set(color) {
            scrollView.backgroundColor = color
        }
    }
    
    @IBInspectable var slideDuration : Double = 0.3
    @IBInspectable var boarderColor : UIColor? {
        get {
            return UIColor(CGColor: selectionBox.layer.borderColor!)
        }
        set(color) {
            selectionBox.layer.borderColor = color?.CGColor
        }
    }
    @IBInspectable var labelTextSize : CGFloat = 15
    
    @IBInspectable var labelLeftMargin : CGFloat = 5
    @IBInspectable var labelTopMargin : CGFloat = 5
    @IBInspectable var spaceBetweenElements : CGFloat = 20
    @IBInspectable var fadeInDelay : Double = 0.2
    @IBInspectable var fadeInDuration : Double = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Setup() // Setup when this component is used from Storyboard
    }
    
    var selectionBoxWidthConstraint : NSLayoutConstraint?
    var selectionBoxCenterXConstraint : NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        view.backgroundColor = scrollBackgroundColor
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        addSubview(view)
        configScrollView()
        print(view.frame.size.height)
        print(scrollView.frame.size.height)
    }
    
    private func configScrollView() {
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        setupSelectionBox()
    }
    
    private func setupSelectionBox() {
        selectionBox.layer.cornerRadius = 5
        selectionBox.clipsToBounds = true
//        selectionBox.layer.borderColor = boarderColor.CGColor
        selectionBox.layer.borderWidth = 1
        selectionBox.backgroundColor = UIColor.clearColor()
        
    }
    
    private func LoadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setUpScrollView(titles titles : [String], var defaultSelection : Int?) {
        if (titles.count <= 0 ){
            return
        }
        
        var selectionBarHeight : CGFloat?
        for var i = 0; i < titles.count; i++ {
            let label : UILabel = UILabel()
            label.text = titles[i]
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.systemFontOfSize(labelTextSize)
            label.sizeToFit()
            let labelWidth : CGFloat = label.frame.size.width
            let labelHeight : CGFloat = label.frame.size.height
            label.frame = CGRectMake(labelLeftMargin, labelTopMargin, labelWidth, labelHeight)
            
            // Setup container view
            let containerView = UIView()
            containerView.alpha = 0
            let containerViewHeight = labelHeight + 2 * labelTopMargin
            selectionBarHeight = containerViewHeight
            let containerViewWidth = labelWidth + 2 * labelLeftMargin
            let widthConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewWidth)
            let heightConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerViewHeight)
            
            var leadingConstraint : NSLayoutConstraint
            if i > 0 {
                let neighbour : UIView = barElements[i - 1]
                leadingConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: neighbour, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: spaceBetweenElements)
            } else {
                leadingConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.scrollView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: spaceBetweenElements)
            }
            
            containerView.tag = i
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleElementTap:")
            containerView.addGestureRecognizer(tapGesture)
            
            containerView.addSubview(label)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(containerView)
            let verticalCenterConstraint = NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            self.view.addConstraints([widthConstraint, heightConstraint, leadingConstraint, verticalCenterConstraint])
            barElements.append(containerView)
            
            let alpha : CGFloat = 1.0
            UIView.animateWithDuration(fadeInDuration, delay: fadeInDelay, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                containerView.alpha = alpha
                }, completion: nil)
        }
//        let selectionBoxCenterYConstraint = NSLayoutConstraint(item: selectionBox, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let selectionBoxHeightConstraint = NSLayoutConstraint(item: selectionBox, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: selectionBarHeight!)
        self.scrollView.addSubview(selectionBox)
//        self.view.addConstraint(selectionBoxCenterYConstraint)
        self.selectionBox.addConstraint(selectionBoxHeightConstraint)
        selectionBox.translatesAutoresizingMaskIntoConstraints = false
        self.selectionBox.layoutIfNeeded()
        self.view.layoutIfNeeded()
        var scrollViewWidth : CGFloat = 0
        for element in barElements {
            scrollViewWidth = scrollViewWidth + element.frame.size.width + spaceBetweenElements
        }
        let scrollViewHeight : CGFloat = self.scrollView.frame.size.height
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight)
        if defaultSelection == nil || (defaultSelection < 0 || defaultSelection >= titles.count) {
            defaultSelection = 0
        }
        markElementAsSelected(atIndex: defaultSelection!)
    }
    
    @objc private func handleElementTap(recognizer: UITapGestureRecognizer) {
        let tappedView : UIView? = recognizer.view
        markElementAsSelected(atIndex: (tappedView?.tag)!)
        delegate?.slideBar(self, didSelectElementAtIndex: (tappedView?.tag)!)
    }
    
    func markElementAsSelected(atIndex index : Int){
        if (index < barElements.count) {
            if selectionBoxWidthConstraint == nil {
                selectionBoxWidthConstraint = NSLayoutConstraint(item: selectionBox, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.barElements[index].frame.width)
            } else {
                selectionBoxWidthConstraint!.constant = self.barElements[index].frame.width
            }
            if selectionBoxCenterXConstraint != nil {
                self.scrollView.removeConstraint(selectionBoxCenterXConstraint!)
            }
            selectionBoxCenterXConstraint = NSLayoutConstraint(item: selectionBox, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.barElements[index], attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.scrollView.addConstraint(selectionBoxCenterXConstraint!)
            
            self.selectionBox.addConstraint(selectionBoxWidthConstraint!)
            UIView.animateWithDuration(slideDuration, delay: 0.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                self.scrollView.layoutIfNeeded()
                self.selectionBox.layoutIfNeeded()
                }, completion: nil)
            scrollToElementIfNecessary(self.barElements[index])
        }
    }
    
    func scrollToElementIfNecessary(selectedElement : UIView) {
        let globalPoint = selectedElement.superview?.convertPoint(selectedElement.frame.origin, toView: nil)
        if (globalPoint?.x)! + selectedElement.frame.size.width > self.superview?.frame.width {
            UIView.animateWithDuration(slideDuration, animations: { () -> Void in
                let difference = (globalPoint?.x)! + selectedElement.frame.size.width + 1/2 * self.spaceBetweenElements - (self.superview?.frame.width)!
                self.scrollView.contentOffset.x += difference
            })
        }
        if (globalPoint?.x)! + selectedElement.frame.size.width < 0 {
            UIView.animateWithDuration(slideDuration, animations: { () -> Void in
                if selectedElement.tag == 0 {
                    self.scrollView.contentOffset.x = 0
                } else {
                    self.scrollView.contentOffset.x = self.selectionBox.frame.origin.x - 1/2 * self.spaceBetweenElements
                }
                
            })
        }
        
    }
}
