//
//  RatingAndFavoriteImpl.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/9/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import UIKit

class RatingAndFavoriteImpl: NSObject, RatingAndFavoriteDelegate {
    
    var baseViewController: UIViewController?
    
    var popUpView=UILabel(frame: CGRectMake(0, 0, 100, 60))
    
    required init(baseVC: UIViewController){
        self.baseViewController = baseVC
    }
    
    
    func like(type: String, objectId: String){
        rate(type, action: "like", objectId: objectId)
    }
    
    func dislike(type: String, objectId: String){
        rate(type, action: "dislike", objectId: objectId)
    }
    
    func neutral(type: String, objectId: String){
        rate(type, action: "neutral", objectId: objectId)
    }
    
    private func rate(type: String, action: String, objectId: String){
        let request: RateRequest = RateRequest()
        request.action = action
        request.type = type
        request.objectId = objectId
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let sessionToken = defaults.stringForKey("sessionToken")
        
        if sessionToken == nil {
            self.configurePopUpView("请登录")
        } else{
            self.baseViewController!.view.userInteractionEnabled = false
            DataAccessor(serviceConfiguration: ParseConfiguration()).rate(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.configureSuccessPopup("评论成功")
                    self.baseViewController!.view.addSubview(self.popUpView)
                    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("popUpDismiss"), userInfo: nil, repeats: false)
                });
            }
        }
    }
    
    func addToFavorites(type: String, objectId: String){
        let request: AddToFavoritesRequest = AddToFavoritesRequest()
        request.type = type
        request.objectId = objectId
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let sessionToken = defaults.stringForKey("sessionToken")
        
        if sessionToken == nil {
            self.configurePopUpView("请登录")
            self.baseViewController!.view.addSubview(self.popUpView)
        } else{
            self.baseViewController!.view.userInteractionEnabled = false
            DataAccessor(serviceConfiguration: ParseConfiguration()).addToFavorites(request) { (response) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.configureSuccessPopup("收藏成功")
                    self.baseViewController!.view.addSubview(self.popUpView)
                    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("popUpDismiss"), userInfo: nil, repeats: false)
                });
            }
        }
    }
    
    private func configurePopUpView(popUpText: String){
        let alertview = JSSAlertView().show(self.baseViewController!, title: popUpText, text: nil, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
    }

    
    private func configureSuccessPopup(popUpText: String) {
        self.popUpView.center = CGPoint(x: self.baseViewController!.view.frame.width / 2, y: self.baseViewController!.view.frame.height / 2)
        self.popUpView.text = popUpText
        self.popUpView.textAlignment = NSTextAlignment.Center
        self.popUpView.backgroundColor=UIColor.grayColor()
    }
    
    func popUpDismiss(){
        self.popUpView.removeFromSuperview()
        self.baseViewController!.view.userInteractionEnabled = true
    }
}
