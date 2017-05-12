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
    
    static var height: CGFloat = 280
    var cellCornerRadius: CGFloat = 2
    var ratingLabelCornerRadius: CGFloat = 3
    
    var restaurant: Restaurant?
    var rank: Int?
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantLocation: UILabel!
    @IBOutlet weak var actualContentView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    
    func setUp(restaurant: Restaurant, rank: Int) {
        self.restaurant = restaurant
        self.rank = rank
        
        if restaurant.name != nil {
            self.restaurantName.text = restaurant.name
        }
        if restaurant.address != nil {
            self.restaurantLocation.text = restaurant.address
        }
        var url: String = ""
        if restaurant.picture?.original != nil {
            url = restaurant.picture!.original!
        }
        restaurantImage.kf.setImage(with: URL(string: url)!, placeholder: UIImage(named: "restaurant_default_background"), options: [.transition(ImageTransition.fade(0.5))])
        
        self.makeRoundedCorner()
        self.configureRatingView()
        self.configureRankView()
        self.configureBorderColor()
    }
    
    fileprivate func makeRoundedCorner(){
        self.actualContentView.layer.cornerRadius = cellCornerRadius
    }
    
    fileprivate func configureRatingView(){
        //self.ratingLabel.text = ScoreComputer.getScore(positive: restaurant!.likeCount, negative: restaurant!.dislikeCount, neutral: restaurant!.neutralCount)
        //self.ratingView.backgroundColor = ScoreComputer.getScoreColor(positive: restaurant!.likeCount, negative: restaurant!.dislikeCount, neutral: restaurant!.neutralCount)
        //self.ratingView.layer.cornerRadius = ratingLabelCornerRadius
    }
    
    fileprivate func configureRankView(){
        self.rankView.backgroundColor = RankColorPicker.colorPicker(rank: self.rank!)
        self.rankView.layer.cornerRadius = self.rankView.frame.size.width / 2
        self.rankLabel.text = String(self.rank!)
    }
    
    fileprivate func configureBorderColor(){
        self.actualContentView.layer.borderWidth = 0.2
        self.actualContentView.layer.borderColor = UIColor.gray.cgColor
    }
}
