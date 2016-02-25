//
//  NotificationTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 2/24/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(title title : String, body : String, read : Bool) {
        if read == true {
            self.titleLabel.text = title
        } else {
            let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(24)]
            let boldTitle = NSMutableAttributedString(string:title, attributes:attrs)
            self.titleLabel.attributedText = boldTitle
        }
        let bodyWithFormat = NSString(format:"<span style=\"font-size: 15\">%@</span>", body) as String
        do {
            let attributedBody = try NSMutableAttributedString(data: bodyWithFormat.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            self.bodyLabel.attributedText = attributedBody
        } catch {
            
        }
        
        
    }

}
