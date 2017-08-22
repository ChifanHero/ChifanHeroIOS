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
    func addBookmarkButtonPressed()
    func writeReviewButtonPressed()
    func addPhotoButtonPressed()
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
            if self.restaurant?.openNow ?? false {
                self.openNowLabel.text = "正在营业"
                self.openNowLabel.textColor = UIColor.chifanHeroGreen()
            } else {
                self.openNowLabel.text = "店家已休息"
                self.openNowLabel.textColor = UIColor.chifanHeroRed()
            }
            self.openTimeTodayLabel.text = self.restaurant?.openTimeToday ?? "今日暂停营业"
            if self.restaurant?.current_user_favorite != nil && self.restaurant?.current_user_favorite == true {
                self.bookmarkImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Bookmarked.png")!, fillColor: UIColor.themeOrange())
            } else {
                self.bookmarkImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Bookmark.png")!, fillColor: UIColor.themeOrange())
            }
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
        
        let addBookmarkTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addBookmarkButtonPressed))
        self.bookmarkImageView.isUserInteractionEnabled = true
        self.bookmarkImageView.addGestureRecognizer(addBookmarkTapGestureRecognizer)
        
        let addReviewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(writeReviewButtonPressed))
        self.addReviewImageView.isUserInteractionEnabled = true
        self.addReviewImageView.addGestureRecognizer(addReviewTapGestureRecognizer)
        
        let addPictureTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addPhotoButtonPressed))
        self.addPictureImageView.isUserInteractionEnabled = true
        self.addPictureImageView.addGestureRecognizer(addPictureTapGestureRecognizer)
    }
    
    func callRestaurant() {
        delegate.callRestaurant()
    }
    
    func startNavigation() {
        startNavigationView.startAnimation()
        delegate.startNavigation()
    }
    
    func writeReviewButtonPressed() {
        delegate.writeReviewButtonPressed()
    }
    
    func addPhotoButtonPressed() {
        delegate.addPhotoButtonPressed()
    }
    
    func addBookmarkButtonPressed() {
        let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40.0, showCloseButton: false, showCircularIcon: true)
        let askLocationAlertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "LogoWithBorder")
        askLocationAlertView.addButton("我知道了", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(self.dismissAlert))
        askLocationAlertView.showInfo("友情提示", subTitle: "收藏功能即将开通", colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
        
        // TODO: Add favorite
        /*if self.restaurant?.current_user_favorite == nil {
            SCLAlertView().showWarning("请登录", subTitle: "登录享受更多便利")
        } else {
            if self.restaurant?.current_user_favorite == true {
                self.restaurant?.current_user_favorite = false
                self.bookmarkImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Bookmark.png")!, fillColor: UIColor.themeOrange())
            } else {
                self.restaurant?.current_user_favorite = true
                self.bookmarkImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Bookmarked.png")!, fillColor: UIColor.themeOrange())
            }
        }*/
        delegate.addBookmarkButtonPressed()
    }

    func dismissAlert() {
        
    }
}
