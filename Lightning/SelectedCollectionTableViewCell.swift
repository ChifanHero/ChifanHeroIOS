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
    
    func setUp(selectedCollection selectedCollection: SelectedCollection) {
        var url: String? = selectedCollection.cellImage?.original
        if(url == nil){
            url = ""
        }
        selectedCollectionImage.kf_setImageWithURL(NSURL(string: url!)!, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(0.5))])
        title.text = selectedCollection.title
    }
}
