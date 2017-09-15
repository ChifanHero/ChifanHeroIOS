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
    
    @IBOutlet weak var clockIcon: UIImageView!
    
    var history : String? {
        didSet {
            historyLabel.text = history
        }
    }

    @IBOutlet weak var deleteButton: UIView!
    
    @IBOutlet weak var deleteButtonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clockIcon.renderColorChangableImage(UIImage(named: "ChifanHero_HistoryClock")!, fillColor: UIColor.lightGray)
        deleteButtonImageView.renderColorChangableImage(UIImage(named: "ChifanHero_Close")!, fillColor: UIColor.lightGray)
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchHistoryTableViewCell.deleteHistory(_:)))
        deleteButton.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func deleteHistory(_ sender: AnyObject) {
        delegate?.deleteHistory(self)
    }
}
