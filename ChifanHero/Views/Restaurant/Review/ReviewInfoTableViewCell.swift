//
//  ReviewInfoTableViewCell.swift
//  ChifanHero
//
//  Created by Shi Yan on 10/30/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ReviewInfoTableViewCell: UITableViewCell {
    
    var nickName: String? {
        didSet {
            usernameLabel.text = nickName
        }
    
    }

    var profileImage: UIImage! {
        didSet {
            self.profilePicImageView.image = profileImage
        }
    }
    
    var reviewTime: String? {
        didSet {
            timeLabel.text = TextUtil.getReviewTimeText(reviewTime!)
        }
    }
    
    var rating: Int? {
        didSet {
            if rating != nil {
                switch rating! {
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
            } else {
                self.reset()
            }
        }
    }
    
    @IBOutlet weak var profilePicImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var ratingOneImageView: UIImageView!
    
    @IBOutlet weak var ratingTwoImageView: UIImageView!
    
    @IBOutlet weak var ratingThreeImageView: UIImageView!
    
    @IBOutlet weak var ratingFourImageView: UIImageView!
    
    @IBOutlet weak var ratingFiveImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicImageView.layer.cornerRadius = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
