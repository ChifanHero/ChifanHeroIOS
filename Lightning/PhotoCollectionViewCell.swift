//
//  PhotoCollectionViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 10/26/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func addPhoto(photo : UIImage) {
        imageView.image = photo
    }
    
}
