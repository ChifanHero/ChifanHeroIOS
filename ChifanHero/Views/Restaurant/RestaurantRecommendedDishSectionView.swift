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
    var delegate: RestaurantRecommendedDishDelegate!
    
    @IBAction func showAllRecommendedDishes(_ sender: Any) {
        delegate.showAllRecommendedDishes()
    }
    
    var recommendedDishes: [RecommendedDish]? {
        didSet {
            if self.recommendedDishes!.count != 0 {
                self.recommendedDishLabel.text = ""
                for index in 0..<recommendedDishes!.count {
                    self.recommendedDishLabel.text?.append(recommendedDishes![index].name ?? "")
                    self.recommendedDishLabel.text?.append("  ")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
