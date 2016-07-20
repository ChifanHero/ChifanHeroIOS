//
//  RestaurantImagePoolCollectionViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/19/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RestaurantImagePoolCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setUp(image image: Picture) {
        var url: String = ""
        url = image.original!
        imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "restaurant_default_background"),optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
    }
    
}
