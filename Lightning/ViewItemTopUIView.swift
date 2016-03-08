//
//  ViewItemTopView.swift
//  SoHungry
//
//  Created by Shi Yan on 8/22/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

@IBDesignable class ViewItemTopUIView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var englishNameLabel: UILabel!
    
    private var rateAndBookmarkExecutor: RatingAndBookmarkExecutor?
    
    var baseVC : UIViewController?
    
    var restaurantId: String?
    
    var view: UIView!
    
    var backgroundImage : UIImage?
    
    var fullBlurEffectApplied = false
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var englishName: String? {
        didSet {
            englishNameLabel.text = englishName
        }
    }
    
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
    var bookmarkCount : Int? {
        didSet {
            if bookmarkCount != nil {
                bookmarkButtonView.actionCount = bookmarkCount!
            } else {
                bookmarkButtonView.actionCount = 0
            }
            
        }
    }
    
    
    @IBOutlet weak var neutralButtonView: ActionButtonView!
    
    @IBOutlet weak var likeButtonView: ActionButtonView!
    
    @IBOutlet weak var dislikeButtonView: ActionButtonView!
    
    @IBOutlet weak var bookmarkButtonView: ActionButtonView!
    
    
    
    @IBInspectable var backgroundImageURL: String? {
        didSet {
            if let imageURL = backgroundImageURL {
                let url = NSURL(string: imageURL)
                let data = NSData(contentsOfURL: url!)
                backgroundImage = UIImage(data: data!)
            } else {
                backgroundImage = UIImage(named: "restaurant_default_background")
            }
            self.backgroundImageView.image = self.blurWithEffects(self.backgroundImage!, factor: 1.0)
            self.fullBlurEffectApplied = true
        }
    }
    
    private func blurWithEffects(image : UIImage, factor : CGFloat) -> UIImage{
        return image.applyBlurWithRadius(10 * factor, tintColor: UIColor(white: 1.0, alpha: 0.7 * factor), saturationDeltaFactor: 1.8)!
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        UISetup()
    }
    
//    func applyBlurEffectToBackgroundImage() {
//        if !blurEffectApplied {
//            if self.backgroundImage != nil {
//                self.backgroundImageView.image = self.blurWithEffects(self.backgroundImage!, factor: 1.0)
//                self.nameLabel.hidden = false
//                self.englishNameLabel.hidden = false
//                self.blurEffectApplied = true
//            }
//        }
//        
//    }
//
//    func clearBlurEffectToBackgroundImage() {
//        if blurEffectApplied {
//            if self.backgroundImage != nil {
//                self.backgroundImageView.image = self.backgroundImage
//                self.nameLabel.hidden = true
//                self.englishNameLabel.hidden = true
//                self.blurEffectApplied = false
//            }
//        }
//    }
    
    func changeBackgroundImageBlurEffect(offSet : CGFloat) {
        let max : CGFloat = 60.0
        let threshold : CGFloat = 100.0
        var current = fabs(offSet) - threshold
        if current < 0.0 {
            current = 0.0
        }
        let factor = (max - current) / max
        
        if factor < 0.6 {
            self.nameLabel.hidden = true
            self.englishNameLabel.hidden = true
        } else {
            self.nameLabel.hidden = false
            self.englishNameLabel.hidden = false
        }
        if self.backgroundImage != nil {
            if factor < 1.0 {
                self.backgroundImageView.image = self.blurWithEffects(self.backgroundImage!, factor: factor)
                fullBlurEffectApplied = false
            }
            if factor == 1.0 && fullBlurEffectApplied == false {
                self.backgroundImageView.image = self.blurWithEffects(self.backgroundImage!, factor: factor)
                fullBlurEffectApplied = true
            }
            
        }
        
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ViewItemTopView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func UISetup() {
//        let blur = UIBlurEffect(style: .ExtraLight)
//        let effectView = UIVisualEffectView(effect: blur)
//        effectView.frame = CGRectMake(0, 0, self.backgroundImageView.frame.width, self.backgroundImageView.frame.height)
//        self.backgroundImageView.addSubview(effectView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    @IBAction func likeAction(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(restaurantId!) {
            JSSAlertView().warning(self.baseVC!, title: "评价太频繁")
        } else {
            likeButtonView.actionCount = likeButtonView.actionCount + 1
            rateAndBookmarkExecutor?.like("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.likeButtonView.actionCount = self.likeButtonView.actionCount - 1
            })
        }
    }

    @IBAction func dislikeAction(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(restaurantId!) {
            JSSAlertView().warning(self.baseVC!, title: "评价太频繁")
        } else {
            dislikeButtonView.actionCount = dislikeButtonView.actionCount + 1
            rateAndBookmarkExecutor?.dislike("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.dislikeButtonView.actionCount = self.dislikeButtonView.actionCount - 1
            })
        }
    }
    

    @IBAction func neutralAction(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if UserContext.isRatingTooFrequent(restaurantId!) {
            JSSAlertView().warning(self.baseVC!, title: "评价太频繁")
        } else {
            neutralButtonView.actionCount = neutralButtonView.actionCount + 1
            rateAndBookmarkExecutor?.neutral("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.neutralButtonView.actionCount = self.neutralButtonView.actionCount - 1
            })
        }
    }
    
    
    @IBAction func bookmarkAction(sender: AnyObject) {
        if self.baseVC == nil {
            return
        }
        rateAndBookmarkExecutor = RatingAndBookmarkExecutor(baseVC: self.baseVC!)
        if !UserContext.isValidUser() {
            JSSAlertView().show(self.baseVC!, title: "请登录", text: nil, buttonText: "我知道了")
        } else {
            bookmarkButtonView.actionCount = bookmarkButtonView.actionCount + 1
            rateAndBookmarkExecutor?.addToFavorites("restaurant", objectId: restaurantId!, failureHandler: { (objectId) -> Void in
                self.bookmarkButtonView.actionCount = self.bookmarkButtonView.actionCount - 1
            })
        }
    }
    
    
}
