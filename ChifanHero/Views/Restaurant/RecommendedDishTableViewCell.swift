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
    var countLabel: UILabel!
    
    var recommendedDish: RecommendedDish! {
        didSet {
            self.nameLabel.text = recommendedDish.name
            self.countLabel.text = String(describing: recommendedDish.recommendationCount ?? 0) + "人推荐"
        }
    }
    
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
        self.nameLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.nameLabel)
        
        self.countLabel = UILabel(frame: CGRect(x: self.contentView.frame.width - 60, y: 10, width: 50, height: self.contentView.frame.height - 20))
        self.countLabel.font = self.countLabel.font.withSize(10)
        self.countLabel.textAlignment = .center
        self.countLabel.textColor = UIColor.themeOrange()
        self.countLabel.layer.borderColor = UIColor.themeOrange().cgColor
        self.countLabel.layer.borderWidth = 1.0
        self.countLabel.layer.cornerRadius = 4.0
        self.countLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.countLabel)
    }
    
    func setUp(_ dish: RecommendedDish) {
        self.recommendedDish = dish
    }

}
