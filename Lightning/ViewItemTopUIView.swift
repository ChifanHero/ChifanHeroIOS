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
    
    var delegate: RatingAndFavoriteDelegate?
    
    var restaurantId: String?
    
    var view: UIView!
    
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
    
    @IBInspectable var backgroundImageURL: String? {
        didSet {
            if let imageURL = backgroundImageURL {
                let url = NSURL(string: imageURL)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                backgroundImageView.image = image
            }
        }
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ViewItemTopView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
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
        delegate?.like("restaurant", objectId: restaurantId!)
    }
    
    @IBAction func dislikeAction(sender: AnyObject) {
        delegate?.dislike("restaurant", objectId: restaurantId!)
    }
    
    @IBAction func neutralAction(sender: AnyObject) {
        delegate?.neutral("restaurant", objectId: restaurantId!)
    }
    
    @IBAction func bookmarkAction(sender: AnyObject) {
        delegate?.addToFavorites("restaurant", objectId: restaurantId!)
    }
    
    
}
