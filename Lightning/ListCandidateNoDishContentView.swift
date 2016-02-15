//
//  ListCandidateNoDishContentView.swift
//  Lightning
//
//  Created by Shi Yan on 2/14/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

@IBDesignable class ListCandidateNoDishContentView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var view : UIView!
    private var nibName : String = "ListCandidateNoDishContentView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view)
        
    }
    
    
    
    func loadViewFromNib() -> UIView{
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }


}
