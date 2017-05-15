//
//  RestaurantImagePoolCollectionViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 7/19/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RestaurantImagePoolCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height))
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(image: UIImage) {
        self.configureCell()
        imageView.image = image
    }
    
    private func configureCell(){
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
}
