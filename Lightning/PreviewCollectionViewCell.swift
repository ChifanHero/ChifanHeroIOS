//
//  PreviewCollectionViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/31/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewCollectionViewCell: UICollectionViewCell {
    
    var restaurant: Restaurant?
    var restaurantImageView: UIImageView?
    var restaurantNameLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        restaurantImageView = UIImageView()
        restaurantImageView?.contentMode = .ScaleAspectFill
        restaurantImageView?.clipsToBounds = true
        self.contentView.addSubview(restaurantImageView!)
        
        restaurantNameLabel = UILabel()
        restaurantNameLabel?.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        self.contentView.addSubview(restaurantNameLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        restaurantImageView?.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height - 60)
        restaurantNameLabel?.frame = CGRect(x: 0, y: self.contentView.frame.height - 60, width: 200, height: 60)
    }
    
    func setUp(restaurant restaurant: Restaurant){
        self.restaurant = restaurant
        self.restaurantNameLabel?.text = restaurant.name
        var url: String? = restaurant.picture?.original
        if url == nil {
            url = ""
        }
        let restaurantDefaultImage = DefaultImageGenerator.generateRestaurantDefaultImage()
//        restaurantImageView!.kf_setImageWithURL(NSURL(string: url!)!, placeholderImage: restaurantDefaultImage,optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
        restaurantImageView!.kf_setImageWithURL(NSURL(string: url!)!, placeholderImage: UIImage(named: "restaurant_default_background"), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            var duration : NSTimeInterval?
            if cacheType == CacheType.Memory {
                duration = 0.0
            } else {
                duration = 1.0
            }
            let newImage : UIImage?
            if image == nil {
                newImage = restaurantDefaultImage
            } else {
                newImage = image
            }
            UIView.transitionWithView(self.restaurantImageView!,
                                      duration:duration!,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { self.restaurantImageView!.image = newImage },
                                      completion: nil)
        }
    }
}
