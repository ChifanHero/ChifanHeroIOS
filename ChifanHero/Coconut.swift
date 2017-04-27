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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class RefreshableViewController: UIViewController, RefreshableViewDelegate {
    
    
    // MARK: - RefreshableViewDelegate
    var noNetworkDefaultView: NoNetworkDefaultView = NoNetworkDefaultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNoNetwork()
    }
    
    func refreshData() {
        
    }
    
    func loadData(_ refreshHandler : ((_ success : Bool) -> Void)?) {
        
    }
    
    func handleNoNetwork(){
        noNetworkDefaultView.translatesAutoresizingMaskIntoConstraints = false
        noNetworkDefaultView.parentVC = self
        self.view.addSubview(noNetworkDefaultView)
        
        let leadingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: noNetworkDefaultView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        self.view.layoutIfNeeded()
        self.view.bringSubview(toFront: noNetworkDefaultView)
        if Reachability.isConnectedToNetwork() {
            noNetworkDefaultView.hide()
        } else {
            noNetworkDefaultView.show()
        }
    }
}

extension UIViewController: ControllerCommonConfigurationDelegate{
    // MARK: - ControllerCommonConfigurationDelegate
    
    func setTabBarVisible(_ visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }) 
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < self.view.frame.maxY
    }
    
    func addImageForBackBarButtonItem(){
        let backBarButtonImage = UIImage(named: "Back_Button")
        self.navigationController?.navigationBar.backIndicatorImage = backBarButtonImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBarButtonImage
    }
    
    func clearTitleForBackBarButtonItem(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func configureNavigationController() {
        self.navigationController!.navigationBar.tintColor = UIColor.white
    }
    
    func setNavigationBarTranslucent(To value: Bool){
        self.navigationController?.navigationBar.isTranslucent = value
    }
}

extension UIView {
    func renderColorChangableImage(_ rawImage: UIImage, fillColor: UIColor) {
        let imageShape = CAShapeLayer()
        let imageFrame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width / rawImage.size.width * rawImage.size.height)
        let imgCenterPoint = CGPoint(x: imageFrame.midX, y: imageFrame.midY)
        imageShape.bounds = imageFrame
        imageShape.position = imgCenterPoint
        imageShape.path = UIBezierPath(rect: imageFrame).cgPath
        imageShape.fillColor = fillColor.cgColor
        
        imageShape.mask = CALayer()
        imageShape.mask!.contents = rawImage.cgImage
        imageShape.mask!.bounds = imageFrame
        imageShape.mask!.position = imgCenterPoint
        
        self.layer.addSublayer(imageShape)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
