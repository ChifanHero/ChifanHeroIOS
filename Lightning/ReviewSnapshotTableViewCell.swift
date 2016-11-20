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
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var levelNameLabel: UILabel!
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var userName : String? {
        didSet {
            nameLabel.text = userName
        }
    }
    
    var review : String? {
        didSet {
            reviewTextView.text = review
        }
    }
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var time: String? {
        didSet {
            if time != nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                let date: NSDate? = dateFormatter.dateFromString(time!)
                if date != nil {
                    let calender: NSCalendar = NSCalendar.currentCalendar()
                    let components = calender.componentsInTimeZone(NSTimeZone.localTimeZone(), fromDate: date!)
                    let currentComponets = calender.componentsInTimeZone(NSTimeZone.localTimeZone(), fromDate: NSDate())
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
                            timeString = "\(hour):\(min)"
                        } else {
                            timeString = "\(month)-\(day) \(hour):\(min)"
                        }
                        
                    } else {
                        timeString = "\(year)-\(month)-\(day)"
                    }
                    timeLabel.text = timeString
                }
                
            }
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
        //profileImageView.layer.cornerRadius = 4
        ratingLabel.layer.cornerRadius = ratingLabel.frame.size.width / 2
        profileImageButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        profileImageButton.layer.cornerRadius = 2
        profileImageButton.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
