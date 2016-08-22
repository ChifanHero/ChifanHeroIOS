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
    
    private func configureCell(){
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    func setUp(image image: UIImage) {
        self.configureCell()
        imageView.image = image
    }
    
    func setUpAddingImageCell(){
        imageView.image = UIImage(named: "CameraAdd")
    }
    
}
