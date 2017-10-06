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
    
    var restaurant: Restaurant!
    var restaurantImageView: UIImageView!
    var restaurantNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureCell(){
        restaurantImageView = UIImageView()
        restaurantImageView.contentMode = .scaleAspectFill
        restaurantImageView.clipsToBounds = true
        self.contentView.addSubview(restaurantImageView)
        
        restaurantNameLabel = UILabel()
        restaurantNameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        self.contentView.addSubview(restaurantNameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        restaurantImageView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height - 60)
        restaurantNameLabel.frame = CGRect(x: 0, y: self.contentView.frame.height - 60, width: 200, height: 60)
    }
    
    func setUp(restaurant: Restaurant){
        self.restaurant = restaurant
        self.restaurantNameLabel.text = restaurant.name
        
        var url: URL!
        if let original = self.restaurant?.picture?.original {
            url = URL(string: original)
        } else if let googlePhotoReference = self.restaurant?.picture?.googlePhotoReference {
            let googlePhotoURL = UrlUtil.getGooglePhotoReferenceUrl() + googlePhotoReference
            url = URL(string: googlePhotoURL)
        } else {
            url = URL(string: "")
        }
        
        restaurantImageView.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(), options: [.transition(ImageTransition.fade(1))])
    }
}
