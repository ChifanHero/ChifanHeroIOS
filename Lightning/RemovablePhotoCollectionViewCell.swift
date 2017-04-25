//
//  RemovablePhotoCollectionViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RemovablePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate func configureCell() {
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func setUp(image: UIImage) {
        self.configureCell()
        imageView.image = image
        
    }
    
    
    func showDeleteButton() {
        deleteButton.layer.cornerRadius = deleteButton.frame.size.width / 2
        deleteButton.renderColorChangableImage(UIImage(named: "Cancel_Button.png")!, fillColor: UIColor.red)
    }
    
    func setUpAddingImageCell(){
        imageView.image = UIImage(named: "CameraAdd")
        deleteButton.isHidden = true
    }
}
