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
    
    class func showErrorAlert(errorCode: Int?, target: AnyObject, buttonAction: Selector) {
        if let errorCode = errorCode {
            switch errorCode {
            case 1000:
                showAlertView(buttonText: "我知道了", infoTitle: "邮箱已存在", infoSubTitle: "请使用不同的邮箱地址", target: target, buttonAction: buttonAction)
            case 1001:
                showAlertView(buttonText: "我知道了", infoTitle: "用户名已存在", infoSubTitle: "请使用不同的用户名", target: target, buttonAction: buttonAction)
            case 1002:
                showAlertView(buttonText: "我知道了", infoTitle: "临时账户已关闭注册", infoSubTitle: "感谢您的支持！请于下个版本注册正式账户！", target: target, buttonAction: buttonAction)
            case 1003:
                showAlertView(buttonText: "我知道了", infoTitle: "邮箱不存在", infoSubTitle: "请核对您的邮箱地址或者重新绑定邮箱", target: target, buttonAction: buttonAction)
            case 209:
                showAlertView(buttonText: "我知道了", infoTitle: "登录已过期", infoSubTitle: "请重新登录", target: target, buttonAction: buttonAction)
            case 101:
                showAlertView(buttonText: "我知道了", infoTitle: "登录失败", infoSubTitle: "用户名（邮箱）或密码错误", target: target, buttonAction: buttonAction)
            case 142:
                showAlertView(buttonText: "我知道了", infoTitle: "无效密码", infoSubTitle: "您所提供的密码不满足安全要求", target: target, buttonAction: buttonAction)
            default:
                showAlertView(buttonText: "我知道了", infoTitle: "未知错误", infoSubTitle: "很抱歉给您带来不便，我们会尽快修复", target: target, buttonAction: buttonAction)
            }
        }
    }
    
    class func showGeneralErrorAlert(target: AnyObject, buttonAction: Selector) {
        showAlertView(buttonText: "我知道了", infoTitle: "网络或系统错误", infoSubTitle: "很抱歉给您带来不便，请稍后再试", target: target, buttonAction: buttonAction)
    }
    
    func doNothing() {}
}
