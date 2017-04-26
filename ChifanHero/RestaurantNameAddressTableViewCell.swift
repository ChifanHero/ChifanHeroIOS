//
//  RestaurantNameAddressTableViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 12/6/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import UIKit

class RestaurantNameAddressTableViewCell: UITableViewCell {
    
    static var height : CGFloat = 44
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIsetUp()
        
    }
    
    func UIsetUp() {

    }
    
    func setUp(restaurant : Restaurant) {
        if let name = restaurant.name {
            nameLabel.text = name
        } else {
            nameLabel.isHidden = true
        }
        
        if let address = restaurant.address {
            addressLabel.text = address
        } else {
            addressLabel.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
