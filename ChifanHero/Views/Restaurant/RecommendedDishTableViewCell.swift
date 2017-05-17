//
//  RecommendedDishTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RecommendedDishTableViewCell: UITableViewCell {

    var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureCell() {
        self.nameLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: self.contentView.frame.height))
        self.nameLabel.font = self.nameLabel.font.withSize(12)
        self.contentView.addSubview(self.nameLabel)
    }
    
    func setUp(_ name: String) {
        self.nameLabel.text = name
    }

}
