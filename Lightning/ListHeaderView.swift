//
//  ListHeaderView.swift
//  SoHungry
//
//  Created by Shi Yan on 10/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class ListHeaderView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var view : UIView!
    private var nibName : String = "ListHeaderView"
    
    private var rateAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var listId: String?
    
    var baseVC : UIViewController?
    
    var delegate : ListHeaderViewDelegate?
    
    @IBOutlet weak var likeButtonView: ActionButtonView!
    
    @IBOutlet weak var bookmarkButtonView: ActionButtonView!
    
    var likeCount : Int? {
        didSet {
            if likeCount != nil {
                likeButtonView.actionCount = likeCount!
            } else {
                likeButtonView.actionCount = 0
            }
            
        }
    }
    var bookmarkCount : Int? {
        didSet {
            if bookmarkCount != nil {
                bookmarkButtonView.actionCount = bookmarkCount!
            } else {
                bookmarkButtonView.actionCount = 0
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    @IBAction func addCandidate(sender: AnyObject) {
        delegate?.addCandidate()
    }
    
    @IBAction func like(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(listId!) {
            JSSAlertView().warning(self.baseVC!, title: "评价太频繁")
        } else {
            likeButtonView.actionCount = likeButtonView.actionCount + 1
            rateAndBookmarkExecutor?.like("list", objectId: listId!, failureHandler: { (objectId) -> Void in
                self.likeButtonView.actionCount = self.likeButtonView.actionCount - 1
            })
        }
    }
    
    @IBAction func bookmark(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if !UserContext.isValidUser() {
            JSSAlertView().show(self.baseVC!, title: "请登录", text: nil, buttonText: "我知道了")
        } else {
            bookmarkButtonView.actionCount = bookmarkButtonView.actionCount + 1
            rateAndBookmarkExecutor?.addToFavorites("restaurant", objectId: listId!, failureHandler: { (objectId) -> Void in
                self.bookmarkButtonView.actionCount = self.bookmarkButtonView.actionCount - 1
            })
        }
    }
    
    
}
