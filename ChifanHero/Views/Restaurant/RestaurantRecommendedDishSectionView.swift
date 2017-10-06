//
//  RestaurantRecommendedDishSectionView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/16/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

protocol RestaurantRecommendedDishDelegate {
    func showAllRecommendedDishes()
}

class RestaurantRecommendedDishSectionView: UIView {

    @IBOutlet weak var recommendedDishLabel: UILabel!
    
    @IBAction func showAllRecommendedDishes(_ sender: Any) {
        delegate.showAllRecommendedDishes()
    }
    
    var delegate: RestaurantRecommendedDishDelegate!
    
    var restaurant: Restaurant! {
        didSet {
            self.configureView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView() {
        if self.restaurant != nil {
            if self.restaurant.recommendedDishes.count != 0 {
                self.recommendedDishLabel.text = ""
                for index in 0..<self.restaurant.recommendedDishes.count {
                    self.recommendedDishLabel.text?.append(self.restaurant.recommendedDishes[index].name ?? "")
                    self.recommendedDishLabel.text?.append("  ")
                }
            }
        }
    }

}
