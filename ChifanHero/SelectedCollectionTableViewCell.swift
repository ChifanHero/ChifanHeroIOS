//
//  ListTableViewCell.swift
//  SoHungry
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit
import Kingfisher

class SelectedCollectionTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 200
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var selectedCollectionImage: UIImageView!
    var imageURL : String = ""
    
    func setUp(selectedCollection: SelectedCollection) {
        var url: String? = selectedCollection.cellImage?.original
        if(url == nil){
            url = ""
        }
        imageURL = url!
        title.text = selectedCollection.title
        selectedCollectionImage.kf.setImage(with: URL(string: imageURL)!, placeholder: UIImage(named: "restaurant_default_background"), options: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            var duration : TimeInterval?
            if cacheType == CacheType.memory {
                duration = 0.0
            } else {
                duration = 1.0
            }
            UIView.transition(with: self.selectedCollectionImage,
                                      duration:duration!,
                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                      animations: { self.selectedCollectionImage.image = image },
                                      completion: nil)
        }
    }
    
}
