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
