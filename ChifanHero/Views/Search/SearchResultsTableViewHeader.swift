//
//  SearchResultsTableViewHeader.swift
//  Lightning
//
//  Created by Shi Yan on 8/7/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SearchResultsTableViewHeader: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    private func setUp(){
        self.logoImageView.image = UIImage(named: "powered_by_google_on_white")
        self.titleLabel.text = "以下为google搜索结果"
    }

}
