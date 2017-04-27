//
//  SearchResultsTableViewHeader.swift
//  Lightning
//
//  Created by Shi Yan on 8/7/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SearchResultsTableViewHeader: UIView {

    fileprivate var view : UIView!
    fileprivate var nibName : String = "SearchResultsTableViewHeader"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title : String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var source : String? {
        didSet {
            if source == "google" {
                logoImageView.image = UIImage(named: "powered_by_google_on_white")
            }
        }
    }
    @IBOutlet weak var logoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    fileprivate func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    }
    
    fileprivate func LoadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
