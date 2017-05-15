//
//  RestaurantInfoSectionView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/13/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

protocol RestaurantInfoSectionDelegate {
    func callRestaurant()
    func startNavigation()
}

class RestaurantInfoSectionView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var openTimeTodayLabel: UILabel!
    
    @IBOutlet weak var callImageView: UIImageView!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var addReviewImageView: UIImageView!
    @IBOutlet weak var addPictureImageView: UIImageView!
    
    @IBOutlet weak var startNavigationView: StartNavigationView!
    
    var restaurant: Restaurant? {
        didSet {
            self.nameLabel.text = restaurant?.name
            self.cityLabel.text = restaurant?.city
            let distanceValue = String(format: "%.1f", restaurant?.distance?.value ?? 0)
            let distanceUnit = restaurant?.distance?.unit ?? "mi"
            self.distanceLabel.text = "\(distanceValue) \(distanceUnit)"
            if restaurant?.openNow ?? false {
                self.openNowLabel.text = "正在营业"
                self.openNowLabel.textColor = UIColor.chifanHeroGreen()
            } else {
                self.openNowLabel.text = "店家已休息"
                self.openNowLabel.textColor = UIColor.chifanHeroRed()
            }
            self.openTimeTodayLabel.text = self.restaurant?.openTimeToday ?? "今日暂停营业"
            
        }
    }
    
    var delegate: RestaurantInfoSectionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    private func setUp() {
        self.callImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Call.png")!, fillColor: UIColor.chifanHeroGreen())
        self.bookmarkImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Bookmark.png")!, fillColor: UIColor.themeOrange())
        self.addReviewImageView.renderColorChangableImage(UIImage(named: "ChifanHero_AddReview.png")!, fillColor: UIColor.chifanHeroBlue())
        self.addPictureImageView.renderColorChangableImage(UIImage(named: "ChifanHero_AddPicture.png")!, fillColor: UIColor.chifanHeroRed())
        
        let callTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callRestaurant))
        self.callImageView.isUserInteractionEnabled = true
        self.callImageView.addGestureRecognizer(callTapGestureRecognizer)
        
        let startNavigationTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startNavigation))
        self.startNavigationView.isUserInteractionEnabled = true
        self.startNavigationView.addGestureRecognizer(startNavigationTapGestureRecognizer)
    }
    
    func callRestaurant() {
        delegate.callRestaurant()
    }
    
    func startNavigation() {
        startNavigationView.startAnimation()
        delegate.startNavigation()
    }

}
