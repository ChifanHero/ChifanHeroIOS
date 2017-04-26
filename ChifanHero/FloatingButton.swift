//
//  FloatingButton.swift
//  Lightning
//
//  Created by Zhang, Alex on 5/19/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {
    
    convenience init(image: UIImage?, backgroundColor: UIColor = UIColor.flatBlueColor) {
        self.init()
        setImage(image, for: UIControlState())
        setBackgroundImage(backgroundColor.pixelImage, for: UIControlState())
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        tintColor = UIColor.white
        if backgroundImage(for: UIControlState()) == nil {
            setBackgroundImage(UIColor.flatBlueColor.pixelImage, for: UIControlState())
        }
        
        layer.cornerRadius = frame.width/2
        layer.masksToBounds = true
    }
    
}
