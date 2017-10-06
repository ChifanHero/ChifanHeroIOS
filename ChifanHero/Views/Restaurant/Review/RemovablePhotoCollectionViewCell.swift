//
//  RemovablePhotoCollectionViewCell.swift
//  Lightning
//
//  Created by Shi Yan on 10/9/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Kingfisher

class RemovablePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private func configureCell() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func setUp(thumbnailUrl: String) {
        self.configureCell()
        let url = URL(string: thumbnailUrl)
        imageView.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(),options: [.transition(ImageTransition.fade(0.5))], completionHandler: { (image, error, cacheType, imageURL) -> () in
        })
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
