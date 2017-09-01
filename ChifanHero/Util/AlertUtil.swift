//
//  AlertUtil.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 9/1/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class AlertUtil {
    class func showAlertView(buttonText: String, infoTitle: String, infoSubTitle: String, target: AnyObject, buttonAction: Selector) {
        let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40.0, showCloseButton: false, showCircularIcon: true)
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "LogoWithBorder")
        alertView.addButton(buttonText, backgroundColor: UIColor.themeOrange(), target: target, selector: buttonAction)
        alertView.showInfo(infoTitle, subTitle: infoSubTitle, colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
    }
    
    class func showAlertViewWithTwoButtons(firstButtonText: String, secondButtonText: String, infoTitle: String, infoSubTitle: String, target: AnyObject, firstButtonAction: Selector, secondButtonAction: Selector) {
        let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40.0, showCloseButton: false, showCircularIcon: true)
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "LogoWithBorder")
        alertView.addButton(firstButtonText, backgroundColor: UIColor.themeOrange(), target: target, selector: firstButtonAction)
        alertView.addButton(secondButtonText, backgroundColor: UIColor.themeOrange(), target: target, selector: secondButtonAction)
        alertView.showInfo(infoTitle, subTitle: infoSubTitle, colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
    }
}
