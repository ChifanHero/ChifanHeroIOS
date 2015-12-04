//
//  MessageTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 9/1/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 75
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var messageSourceLabel: UILabel!
    
    @IBOutlet weak var messageTitleLabel: UILabel!
    
    var icon : UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    var source : String? {
        didSet {
            messageSourceLabel.text = source
        }
    }
    
    var title : String? {
        didSet {
            messageTitleLabel.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        UISetup()
        // Initialization code
    }
    
    private func UISetup() {
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
