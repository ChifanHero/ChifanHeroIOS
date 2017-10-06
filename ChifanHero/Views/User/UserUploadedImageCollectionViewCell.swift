//
//  UserUploadedImageCollectionViewCell.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/21/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class UserUploadedImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureCell(){
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height))
        imageView!.contentMode = .scaleAspectFill
        imageView!.clipsToBounds = true
        self.contentView.addSubview(imageView!)
    }
    
    func setUpImage(_ image: UIImage) {
        self.imageView?.image = image
    }
}
