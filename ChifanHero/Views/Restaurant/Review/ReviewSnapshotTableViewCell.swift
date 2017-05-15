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
            self.nameLabel.text = self.review.user?.nickName ?? "匿名用户"
            
            if let time = review.lastUpdateTime {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                let date: Date? = dateFormatter.date(from: time)
                if date != nil {
                    let calender: Calendar = Calendar.current
                    let components = calender.dateComponents(in: TimeZone.autoupdatingCurrent, from: date!)
                    let currentComponets = calender.dateComponents(in: TimeZone.autoupdatingCurrent, from: Date())
                    var timeString = ""
                    let year = components.year
                    let currentYear = currentComponets.year
                    let month = components.month
                    let currentMonth = currentComponets.month
                    let day = components.day
                    let currentDay = currentComponets.day
                    let hour = components.hour
                    let min = components.minute
                    if year == currentYear {
                        if month == currentMonth && day == currentDay {
                            timeString = "\(hour!):\(min!)"
                        } else {
                            timeString = "\(month!)-\(day!) \(hour!):\(min!)"
                        }
                        
                    } else {
                        timeString = "\(year!)-\(month!)-\(day!)"
                    }
                    timeLabel.text = timeString
                }
                
            }
        }
    }
    
    let dateFormatter: DateFormatter = DateFormatter()
    
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
