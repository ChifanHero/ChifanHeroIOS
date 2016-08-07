//
//  SearchResultsTableViewHeader.swift
//  Lightning
//
//  Created by Shi Yan on 8/7/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SearchResultsTableViewHeader: UIView {

    private var view : UIView!
    private var nibName : String = "SearchResultsTableViewHeader"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title : String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var logo : String? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Setup() // Setup when this component is used from Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Setup() // Setup when this component is used from Code
    }
    
    private func Setup(){
        view = LoadViewFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    }
    
    private func LoadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
