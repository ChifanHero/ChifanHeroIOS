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
    
    func setUp(selectedCollection selectedCollection: SelectedCollection) {
        var url: String? = selectedCollection.cellImage?.original
        if(url == nil){
            url = ""
        }
        imageURL = url!
        title.text = selectedCollection.title
        selectedCollectionImage.kf_setImageWithURL(NSURL(string: imageURL)!, placeholderImage: UIImage(named: "restaurant_default_background"), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) in
            var duration : NSTimeInterval?
            if cacheType == CacheType.Memory {
                duration = 0.0
            } else {
                duration = 1.0
            }
            UIView.transitionWithView(self.selectedCollectionImage,
                                      duration:duration!,
                                      options: UIViewAnimationOptions.TransitionCrossDissolve,
                                      animations: { self.selectedCollectionImage.image = image },
                                      completion: nil)
        }
    }
    
}
