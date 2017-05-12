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
        self.tintColor = UIColor.clear
        pullView.image = UIImage(named: "Pull_To_Refresh.png")
        pullView.contentMode = .scaleToFill
        pullView.frame.origin.x = ((UIApplication.shared.delegate as? AppDelegate)?.window?.frame.width)! / 2 - pullView.frame.width / 2
        pullView.frame.origin.y = 10
        self.addSubview(pullView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animateRefreshView() {
        
        UIView.animate(
            withDuration: Double(0.1),
            delay: Double(0.0),
            options: UIViewAnimationOptions.curveLinear,
            animations: {
                // Rotate the spinner by Double.pi_2 = PI/2 = 90 degrees
                self.pullView.transform = self.pullView.transform.rotated(by: CGFloat(Double.pi / 2))
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if self.isRefreshing {
                    self.animateRefreshView()
                }else {
                    
                }
            }
        )
    }

}
