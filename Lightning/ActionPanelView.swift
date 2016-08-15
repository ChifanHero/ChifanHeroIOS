//
//  ActionPanelView.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class ActionPanelView: UIView {

    private var rateAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var baseVC: UIViewController?
    
    var restaurantId: String?
    
    var view: UIView!
    
    @IBOutlet weak var likeButtonView: ActionButtonView!
    
    @IBOutlet weak var neutralButtonView: ActionButtonView!
    
    @IBOutlet weak var dislikeButtonView: ActionButtonView!
    
    @IBOutlet weak var favoriteButtonView: ActionButtonView!
    
    var likeCount : Int? {
        didSet {
            if likeCount != nil {
                likeButtonView.actionCount = likeCount!
            } else {
                likeButtonView.actionCount = 0
            }
            
        }
    }
    var dislikeCount : Int? {
        didSet {
            if dislikeCount != nil {
                dislikeButtonView.actionCount = dislikeCount!
            } else {
                dislikeButtonView.actionCount = 0
            }
            
        }
    }
    var neutralCount : Int? {
        didSet {
            if neutralCount != nil {
                neutralButtonView.actionCount = neutralCount!
            } else {
                neutralButtonView.actionCount = 0
            }
            
        }
    }
    var favoriteCount : Int? {
        didSet {
            if favoriteCount != nil {
                favoriteButtonView.actionCount = favoriteCount!
            } else {
                favoriteButtonView.actionCount = 0
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ActionPanel", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    @IBAction func like(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(restaurantId!) {
            SCLAlertView().showWarning("评价太频繁", subTitle: "请勿频繁评价")
        } else {
            likeButtonView.actionCount = likeButtonView.actionCount + 1
            rateAndBookmarkExecutor?.like("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.likeButtonView.actionCount = self.likeButtonView.actionCount - 1
            })
        }
    }
    
    
    @IBAction func neutral(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(restaurantId!) {
            SCLAlertView().showWarning("评价太频繁", subTitle: "请勿频繁评价")
        } else {
            neutralButtonView.actionCount = neutralButtonView.actionCount + 1
            rateAndBookmarkExecutor?.neutral("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.neutralButtonView.actionCount = self.neutralButtonView.actionCount - 1
            })
        }
    }
    
    @IBAction func dislike(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(restaurantId!) {
            SCLAlertView().showWarning("评价太频繁", subTitle: "请勿频繁评价")
        } else {
            dislikeButtonView.actionCount = dislikeButtonView.actionCount + 1
            rateAndBookmarkExecutor?.dislike("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.dislikeButtonView.actionCount = self.dislikeButtonView.actionCount - 1
            })
        }
    }
    
    @IBAction func favorite(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if !UserContext.isValidUser() {
            SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
        } else {
            favoriteButtonView.actionCount = favoriteButtonView.actionCount + 1
            rateAndBookmarkExecutor?.addToFavorites("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.favoriteButtonView.actionCount = self.favoriteButtonView.actionCount - 1
            })
        }
    }
    
    
}
