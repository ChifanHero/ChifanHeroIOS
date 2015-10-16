//
//  ListTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 50.0
    
    var model : Model? {
        didSet {
            if let list = model as? List {
                nameLabel.text = list.name
                if (list.memberCount != nil) {
                    countLabel.text = String(list.memberCount!) + "道菜"
                }
            }
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUp()
    }
    
    func setUp() {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
