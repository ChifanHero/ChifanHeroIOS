//
//  RestaurantCollectionMemberTableViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/4/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantCollectionMemberTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 200
    var cellCornerRadius: CGFloat = 2
    var ratingLabelCornerRadius: CGFloat = 3
    
    var restaurant: Restaurant?
    var rank: Int?
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var actualContentView: UIView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setUp(restaurant: Restaurant, rank: Int) {
        self.restaurant = restaurant
        self.rank = rank
        
        ratingLabel.layer.cornerRadius = 4
        ratingLabel.isHidden = true
        distanceLabel.isHidden = true
        
        if restaurant.name != nil {
            self.restaurantName.text = restaurant.name
        }
        
        self.ratingLabel.text = String(format:"%.1f", self.restaurant?.rating ?? 0)
        self.ratingLabel.backgroundColor = ScoreComputer.getScoreColor(self.restaurant?.rating ?? 0)
        self.ratingLabel.isHidden = false
        
        if restaurant.distance != nil {
            let distanceValue = String(format: "%.1f", restaurant.distance!.value ?? 0)
            let distanceUnit = restaurant.distance!.unit ?? "mi"
            self.distanceLabel.text = "\(distanceValue) \(distanceUnit)"
            self.distanceLabel.isHidden = false
        }
        
        var url: URL!
        if let original = self.restaurant?.picture?.original {
            url = URL(string: original)
        } else if let googlePhotoReference = self.restaurant?.picture?.googlePhotoReference {
            let googlePhotoURL = UrlUtil.getGooglePhotoReferenceUrl() + googlePhotoReference
            url = URL(string: googlePhotoURL)
        } else {
            url = URL(string: "")
        }
        
        restaurantImage.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(), options: [.transition(ImageTransition.fade(0.5))])
        
        self.makeRoundedCorner()
        self.configureBorderColor()
    }
    
    private func makeRoundedCorner(){
        self.actualContentView.layer.cornerRadius = cellCornerRadius
    }
    
    private func configureBorderColor(){
        self.actualContentView.layer.borderWidth = 0.2
        self.actualContentView.layer.borderColor = UIColor.gray.cgColor
    }
}
