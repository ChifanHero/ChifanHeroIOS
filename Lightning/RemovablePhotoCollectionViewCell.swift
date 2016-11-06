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
    
    private func configureCell() {
        
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
    }
    
    func setUp(image image: UIImage) {
        self.configureCell()
        imageView.image = image
        
    }
    
    
    func showDeleteButton() {
        deleteButton.layer.cornerRadius = deleteButton.frame.size.width / 2
        deleteButton.renderColorChangableImage(UIImage(named: "Cancel_Button.png")!, fillColor: UIColor.redColor())
    }
    
    func setUpAddingImageCell(){
        imageView.image = UIImage(named: "CameraAdd")
        deleteButton.hidden = true
    }
}
