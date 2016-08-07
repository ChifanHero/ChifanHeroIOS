//
//  RefreshableViewController.swift
//  Lightning
//
//  Created by Shi Yan on 3/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import UIKit
import Flurry_iOS_SDK

class RefreshableViewController: UIViewController, RefreshableViewDelegate {
    
    
    // MARK: - RefreshableViewDelegate
    var noNetworkDefaultView: NoNetworkDefaultView = NoNetworkDefaultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNoNetwork()
    }
    
    func refreshData() {
        
    }
    
    func loadData(refreshHandler : ((success : Bool) -> Void)?) {
        
    }
    
    func handleNoNetwork(){
        noNetworkDefaultView.translatesAutoresizingMaskIntoConstraints = false
        noNetworkDefaultView.parentVC = self
        self.view.addSubview(noNetworkDefaultView)
        
        let leadingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        self.view.layoutIfNeeded()
        self.view.bringSubviewToFront(noNetworkDefaultView)
        if Reachability.isConnectedToNetwork() {
            noNetworkDefaultView.hide()
        } else {
            noNetworkDefaultView.show()
        }
    }
}

extension UIViewController: ControllerCommonConfigurationDelegate{
    // MARK: - ControllerCommonConfigurationDelegate
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    func addImageForBackBarButtonItem(){
        let backBarButtonImage = UIImage(named: "Back_Button")
        self.navigationController?.navigationBar.backIndicatorImage = backBarButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBarButtonImage
    }
    
    func clearTitleForBackBarButtonItem(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    func configureNavigationController() {
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func setNavigationBarTranslucent(To value: Bool){
        self.navigationController?.navigationBar.translucent = value
    }
}

extension UIView {
    func renderColorChangableImage(rawImage: UIImage, fillColor: UIColor) {
        let imageShape = CAShapeLayer()
        let imageFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width / rawImage.size.width * rawImage.size.height)
        let imgCenterPoint = CGPointMake(CGRectGetMidX(imageFrame), CGRectGetMidY(imageFrame))
        imageShape.bounds = imageFrame
        imageShape.position = imgCenterPoint
        imageShape.path = UIBezierPath(rect: imageFrame).CGPath
        imageShape.fillColor = fillColor.CGColor
        
        imageShape.mask = CALayer()
        imageShape.mask!.contents = rawImage.CGImage
        imageShape.mask!.bounds = imageFrame
        imageShape.mask!.position = imgCenterPoint
        
        self.layer.addSublayer(imageShape)
    }
}
