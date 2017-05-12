//
//  ButtonUtil.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 4/26/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class ButtonUtil {
    class func barButtonWithTextAndBorder(_ title: String, size: CGRect) -> UIButton{
        let button: UIButton = UIButton(type: .custom)
        button.frame = size
        button.layer.cornerRadius = 3.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle(title, for: UIControlState())
        button.titleLabel!.font =  UIFont(name: "Arial", size: 14)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.themeOrange()
        return button
    }
}
