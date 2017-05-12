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
    
    var popUpView=UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
    
    required init(baseVC: UIViewController){
        self.baseViewController = baseVC
    }
    
    
    func like(_ type: String, objectId: String, failureHandler: ((String) -> Void)?){
        rate(type, action: "like", objectId: objectId, failureHandler: failureHandler)
    }
    
    func dislike(_ type: String, objectId: String, failureHandler: ((String) -> Void)?){
        rate(type, action: "dislike", objectId: objectId, failureHandler: failureHandler)
    }
    
    func neutral(_ type: String, objectId: String, failureHandler: ((String) -> Void)?){
        rate(type, action: "neutral", objectId: objectId, failureHandler: failureHandler)
    }
    
    fileprivate func rate(_ type: String, action: String, objectId: String, failureHandler: ((String) -> Void)?){
        let request: RateRequest = RateRequest()
        request.action = action
        request.type = type
        request.objectId = objectId
        let defaults = UserDefaults.standard
        let now : Int = Int(Date().timeIntervalSince1970 * 1000)
        defaults.set(now, forKey: objectId)
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).rate(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                
                if response == nil || response?.error != nil{
                    if failureHandler != nil {
                        failureHandler!(objectId)
                    }
                }
                
            });
        }
    }
    
    func addToFavorites(_ type: String, objectId: String, failureHandler: ((String) -> Void)?){
        let request: AddToFavoritesRequest = AddToFavoritesRequest()
        request.type = type
        request.objectId = objectId
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).addToFavorites(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                
                if response?.error == nil {
                    
                } else {
                    if failureHandler != nil {
                        failureHandler!(objectId)
                    }
                }
                
            });
        }
        
    }
    
    func removeFavorite(_ type: String, objectId: String, successHandler: (() -> Void)?){
        let request: RemoveFavoriteRequest = RemoveFavoriteRequest()
        request.type = type
        request.objectId = objectId
        
        DataAccessor(serviceConfiguration: ParseConfiguration()).removeFavorite(request) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                
                if response?.error == nil {
                    if successHandler != nil {
                        successHandler!()
                    }
                } else {
                    
                }
                
            });
        }
        
    }
    
    
    fileprivate func configureSuccessPopup(_ popUpText: String) {
        self.popUpView.center = CGPoint(x: self.baseViewController!.view.frame.width / 2, y: self.baseViewController!.view.frame.height / 2)
        self.popUpView.text = popUpText
        self.popUpView.textAlignment = NSTextAlignment.center
        self.popUpView.backgroundColor=UIColor.gray
    }
    
    func popUpDismiss(){
        self.popUpView.removeFromSuperview()
        self.baseViewController!.view.isUserInteractionEnabled = true
    }
}
