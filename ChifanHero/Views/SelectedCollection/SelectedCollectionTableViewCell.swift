//
//  SelectedCollectionTableViewCell
//  ChifanHero
//
//  Created by Shi Yan on 8/21/15.
//  Copyright © 2015 ChifanHero. All rights reserved.
//

import UIKit
import Kingfisher

class SelectedCollectionTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 200
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var selectedCollectionImage: UIImageView!
    
    func setUp(selectedCollection: SelectedCollection) {
        let url = URL(string: selectedCollection.cellImage?.original ?? "")
        title.text = selectedCollection.title
        selectedCollectionImage.kf.setImage(with: url, placeholder: DefaultImageGenerator.generateRestaurantDefaultImage(), options: [.transition(ImageTransition.fade(0.5))])
    }
    
}
