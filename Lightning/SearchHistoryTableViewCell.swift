//
//  SearchHistoryTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 8/6/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyLabel: UILabel!
    var delegate : SearchHistoryCellDelegate?
    
    
    var history : String? {
        didSet {
            historyLabel.text = history
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteHistory(sender: AnyObject) {
        delegate?.deleteHistory(self)
    }
}
