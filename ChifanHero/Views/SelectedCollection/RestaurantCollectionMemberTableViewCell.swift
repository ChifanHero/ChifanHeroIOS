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
    
    func setUp(restaurant: Restaurant, rank: Int) {
        self.restaurant = restaurant
        self.rank = rank
        
        if restaurant.name != nil {
            self.restaurantName.text = restaurant.name
        }
        let url: URL! = URL(string: restaurant.picture?.original ?? "")
        restaurantImage.kf.setImage(with: url, placeholder: UIImage(named: "restaurant_default_background"), options: [.transition(ImageTransition.fade(0.5))])
        
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
