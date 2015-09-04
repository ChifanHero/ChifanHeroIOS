//
//  SlideBar.swift
//  HorizontalScroll
//
//  Created by Shi Yan on 8/25/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class SlideBar: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view: UIView!
    private var nibName: String  = "SlideBar"
    
    private var elementCover : UIView?
    
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
    @IBInspectable var boarderColor : UIColor = UIColor.orangeColor()
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
    
    func setUpScrollView(titles titles : [String], var defaultSelection : Int?) {
        
        
        if (titles.count <= 0 ){
            return
        }
        
        let padding = spaceBetweenElements / 2
        
        for var i = 0; i < titles.count; i++ {
            let label : UILabel = UILabel()
            label.text = titles[i]
            label.font = UIFont.systemFontOfSize(labelTextSize)
            label.sizeToFit()
            let labelWidth : CGFloat = label.frame.size.width
            let labelHeight : CGFloat = label.frame.size.height
            label.frame = CGRectMake(labelLeftMargin, labelTopMargin, labelWidth, labelHeight)
            
            // Setup container view
            let containerView = UIView()
            containerView.alpha = 0
            let containerViewHeight = labelHeight + 2 * labelTopMargin
            let containerViewWidth = labelWidth + 2 * labelLeftMargin
            var x = padding
            for previousView in barElements {
                x = x + previousView.frame.size.width + spaceBetweenElements
            }
            let y = (view.frame.size.height - containerViewHeight) / 2
            containerView.frame = CGRectMake(x, y, containerViewWidth, containerViewHeight)
            containerView.tag = i
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleElementTap:")
            containerView.addGestureRecognizer(tapGesture)
            
            containerView.addSubview(label)
            self.scrollView.addSubview(containerView)
            barElements.append(containerView)
            
            let alpha : CGFloat = 1.0
            UIView.animateWithDuration(fadeInDuration, delay: fadeInDelay, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                    containerView.alpha = alpha
                }, completion: nil)
        }
        var scrollViewWidth : CGFloat = 0
        for element in barElements {
            scrollViewWidth = scrollViewWidth + element.frame.size.width + spaceBetweenElements
        }
        let scrollViewHeight : CGFloat = self.frame.size.height
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth, scrollViewHeight)
        if defaultSelection == nil || defaultSelection! < 0 && defaultSelection >= titles.count {
            defaultSelection = 0
        }
        let firstElement : UIView = barElements[defaultSelection!]
        
        elementCover = UIView(frame: firstElement.frame)
        elementCover!.layer.cornerRadius = 5
        elementCover!.clipsToBounds = true
        elementCover!.layer.borderColor = boarderColor.CGColor
        elementCover!.layer.borderWidth = 1
        elementCover!.center = firstElement.center
        self.scrollView.addSubview(elementCover!)
        
    }
    
    @objc private func handleElementTap(recognizer: UITapGestureRecognizer) {
        let tappedView : UIView? = recognizer.view
        selectElement(atIndex: (tappedView?.tag)!)
        delegate?.slideBar(self, didSelectElementAtIndex: (tappedView?.tag)!)
    }
    
    func selectElement(atIndex index : Int){
        if (index < barElements.count) {
            UIView.animateWithDuration(slideDuration, delay: 0.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                self.elementCover?.frame = barElements[index].frame
                }, completion: nil)
        }
    }

}
