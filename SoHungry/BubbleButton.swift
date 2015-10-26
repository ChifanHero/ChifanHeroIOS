//
//  BubbleButton.swift
//  SoHungry
//
//  Created by Shi Yan on 10/25/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class BubbleButton: UIButton {
    
    var animator : UIDynamicAnimator!
    var floatingBehavior : FloatingBehavior!
    var view : UIView!
    var itemView : UIView!
    var offset = CGPoint.zero
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(containerView containerView : UIView) {
        let pan : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "drag:")
        self.addGestureRecognizer(pan)
        view = containerView
        itemView = self
        animator = UIDynamicAnimator(referenceView: view)
        floatingBehavior = FloatingBehavior(item: self)
        animator.addBehavior(floatingBehavior)
    }
    
    func drag(gesture: UIPanGestureRecognizer) {
        var location = gesture.locationInView(view)
        
        switch gesture.state {
        case .Began:
            // Capture the initial touch offset from the itemView's center.
            let center = itemView.center
            offset.x = location.x - center.x
            offset.y = location.y - center.y
            
            // Disable the behavior while the item is manipulated by the pan recognizer.
            floatingBehavior.isEnabled = false
            
        case .Changed:
            // Get reference bounds.
            let referenceBounds = view.bounds
            let referenceWidth = referenceBounds.width
            let referenceHeight = referenceBounds.height
            
            // Get item bounds.
            let itemBounds = itemView.bounds
            let itemHalfWidth = itemBounds.width / 2.0
            let itemHalfHeight = itemBounds.height / 2.0
            
            // Apply the initial offset.
            location.x -= offset.x
            location.y -= offset.y
            
            // Bound the item position inside the reference view.
            location.x = max(itemHalfWidth, location.x)
            location.x = min(referenceWidth - itemHalfWidth, location.x)
            location.y = max(itemHalfHeight, location.y)
            location.y = min(referenceHeight - itemHalfHeight, location.y)
            
            // Apply the resulting item center.
            itemView.center = location
            
        case .Cancelled, .Ended:
            // Get the current velocity of the item from the pan gesture recognizer.
            let velocity = gesture.velocityInView(view)
            
            // Re-enable the floatingBehavior.
            floatingBehavior.isEnabled = true
            
            // Add the current velocity to the floatingBehavior.
            floatingBehavior.addLinearVelocity(velocity)
            
        default: ()
        }
        
    }
    
}
