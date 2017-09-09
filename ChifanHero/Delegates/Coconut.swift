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
    
    func tabBarIsVisible() -> Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY
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
        
        if self.layer.sublayers != nil {
            for layer in self.layer.sublayers! {
                layer.removeFromSuperlayer()
            }
        }
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

extension UITableViewCell {
    
    func changeTitleForActionView(_ newTitle : String, index : Int) {
        
        var deleteConfirmationView: UIView?
        for subview in subviews {
            if subview.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
                deleteConfirmationView = subview
                break
            }
        }
        
        if let unwrappedDeleteView = deleteConfirmationView {
            let actionbuttons = unwrappedDeleteView.value(forKey: "_actionButtons") as? [AnyObject]
            
            if let actionButton = actionbuttons?[index] as? UIButton {
                
                actionButton.setTitle(newTitle, for: UIControlState())
            }
            
        }
        
    }
    
}
