//
//  PullToRefreshControl.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class PullToRefreshControl: UIRefreshControl {
    
    let pullView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override init() {
        super.init()
        self.tintColor = UIColor.clearColor()
        pullView.image = UIImage(named: "Pull_To_Refresh.png")
        pullView.contentMode = .ScaleToFill
        pullView.frame.origin.x = ((UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.frame.width)! / 2 - pullView.frame.width / 2
        pullView.frame.origin.y = 10
        self.addSubview(pullView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateRefreshView() {
        
        UIView.animateWithDuration(
            Double(0.1),
            delay: Double(0.0),
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                self.pullView.transform = CGAffineTransformRotate(self.pullView.transform, CGFloat(M_PI_2))
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if self.refreshing {
                    self.animateRefreshView()
                }else {
                    
                }
            }
        )
    }

}
