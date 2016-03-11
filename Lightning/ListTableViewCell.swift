//
//  ListTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 200
    
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
    @IBOutlet weak var listImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(list list: List, image: UIImage) {
        listImage.image = image
        nameLabel.text = list.name
        if (list.memberCount != nil) {
            countLabel.text = String(list.memberCount!) + "道菜"
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
