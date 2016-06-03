//
//  RatingAndFavoriteImpl.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/9/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import UIKit

class RatingAndBookmarkExecutor {
    
    var baseViewController: UIViewController?
    
    var popUpView=UILabel(frame: CGRectMake(0, 0, 100, 60))
    
    required init(baseVC: UIViewController){
        self.baseViewController = baseVC
    }
    
    
    func like(type: String, objectId: String, failureHandler: ((String) -> Void)?){
        rate(type, action: "like", objectId: objectId, failureHandler: failureHandler)
    }
    
    func dislike(type: String, objectId: String, failureHandler: ((String) -> Void)?){
        rate(type, action: "dislike", objectId: objectId, failureHandler: failureHandler)
    }
    
    func neutral(type: String, objectId: String, failureHandler: ((String) -> Void)?){
        rate(type, action: "neutral", objectId: objectId, failureHandler: failureHandler)
    }
    
    private func rate(type: String, action: String, objectId: String, failureHandler: ((String) -> Void)?){
        let request: RateRequest = RateRequest()
        request.action = action
        request.type = type
        request.objectId = objectId
        let defaults = NSUserDefaults.standardUserDefaults()
        let now : Int = Int(NSDate().timeIntervalSince1970 * 1000)
        defaults.setInteger(now, forKey: objectId)
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).rate(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if response == nil || response?.error != nil{
                    if failureHandler != nil {
                        failureHandler!(objectId)
                    }
                }
                
            });
        }
    }
    
    func addToFavorites(type: String, objectId: String, failureHandler: ((String) -> Void)?){
        let request: AddToFavoritesRequest = AddToFavoritesRequest()
        request.type = type
        request.objectId = objectId
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).addToFavorites(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if response?.error == nil {
                    
                } else {
                    if failureHandler != nil {
                        failureHandler!(objectId)
                    }
                }
                
            });
        }
        
    }
    
    func removeFavorite(type: String, objectId: String, successHandler: (() -> Void)?){
        let request: RemoveFavoriteRequest = RemoveFavoriteRequest()
        request.type = type
        request.objectId = objectId
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).removeFavorite(request) { (response) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if response?.error == nil {
                    if successHandler != nil {
                        successHandler!()
                    }
                } else {
                    
                }
                
            });
        }
        
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
