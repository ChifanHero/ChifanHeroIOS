//
//  RestaurantNominationCollectionViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantNominationCollectionViewCell: UICollectionViewCell {
    
    var restaurant: Restaurant?
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    func setUp(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        if restaurant.name != nil {
            self.restaurantName.text = restaurant.name
        }
        var url: String = ""
        if restaurant.picture?.original != nil {
            url = restaurant.picture!.original!
        }
        restaurantImage.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "restaurant_default_background"),options: [.transition(ImageTransition.fade(0.5))])
        
        configureCell()
    }
    
    override var isSelected: Bool {
        
        didSet {
            if isSelected {
                self.layer.borderWidth = 2.0
                self.layer.borderColor = UIColor.themeOrange().cgColor
            } else {
                self.layer.borderWidth = 0.3
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    
    fileprivate func configureCell(){
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
}
