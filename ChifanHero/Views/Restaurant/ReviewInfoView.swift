//
//  ReviewInfoView.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 5/18/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class ReviewInfoView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ratingOneImageView: UIImageView!
    @IBOutlet weak var ratingTwoImageView: UIImageView!
    @IBOutlet weak var ratingThreeImageView: UIImageView!
    @IBOutlet weak var ratingFourImageView: UIImageView!
    @IBOutlet weak var ratingFiveImageView: UIImageView!
    @IBOutlet weak var ratingTimeLabel: UILabel!
    
    var review: Review! {
        didSet {
            self.setUp()
        }
    }
    
    var profileImage: UIImage! {
        didSet {
            self.profileImageView.image = profileImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setUp() {
        self.userNameLabel.text = self.review.user?.nickName ?? "无名英雄"
        self.ratingTimeLabel.text = TextUtil.getReviewTimeText(self.review.lastUpdateTime!)
        self.profileImageView.layer.cornerRadius = 4
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.clipsToBounds = true
        switch self.review.rating {
        case 1:
            self.ratingOne()
        case 2:
            self.ratingTwo()
        case 3:
            self.ratingThree()
        case 4:
            self.ratingFour()
        case 5:
            self.ratingFive()
        default:
            self.reset()
        }
    }
    
    func reset() {
        RatingStarUtil.noRating(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingOne() {
        RatingStarUtil.ratingOne(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingTwo() {
        RatingStarUtil.ratingTwo(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingThree() {
        RatingStarUtil.ratingThree(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingFour() {
        RatingStarUtil.ratingFour(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }
    
    func ratingFive() {
        RatingStarUtil.ratingFive(ratingOneImageView: ratingOneImageView, ratingTwoImageView: ratingTwoImageView, ratingThreeImageView: ratingThreeImageView, ratingFourImageView: ratingFourImageView, ratingFiveImageView: ratingFiveImageView)
    }

}
