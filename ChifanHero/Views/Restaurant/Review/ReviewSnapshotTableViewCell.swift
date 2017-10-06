//
//  ReviewSnapshotTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class ReviewSnapshotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var ratingOneImageView: UIImageView!
    @IBOutlet weak var ratingTwoImageView: UIImageView!
    @IBOutlet weak var ratingThreeImageView: UIImageView!
    @IBOutlet weak var ratingFourImageView: UIImageView!
    @IBOutlet weak var ratingFiveImageView: UIImageView!
    
    var review: Review! {
        didSet {
            self.reviewTextView.text = review.content
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
            self.nameLabel.text = self.review.user?.nickName ?? "无名英雄"
            
            self.timeLabel.text = TextUtil.getReviewTimeText(self.review.lastUpdateTime!)
        }
    }
    
    var profileImage: UIImageView! {
        didSet {
            self.profileImageButton.setImage(self.profileImage.image, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    private func setUp() {
        profileImageButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        profileImageButton.layer.cornerRadius = 2
        profileImageButton.clipsToBounds = true
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
