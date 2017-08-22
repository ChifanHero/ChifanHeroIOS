//
//  UpdateRestaurantViewController.swift
//  ChifanHero
//
//  Created by Zhang, Alex on 8/22/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class UpdateRestaurantViewController: UIViewController {

    @IBOutlet weak var restaurantNameTextField: UITextField!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButton()
    }
    
    private func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("提交", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(submit), for: UIControlEvents.touchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func submit() {
        let updateRestaurantInfoRequest = UpdateRestaurantInfoRequest()
        
        if let restaurantName = restaurantNameTextField.text {
            if restaurantName.isEmpty {
                let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40.0, showCloseButton: false, showCircularIcon: true)
                let askLocationAlertView = SCLAlertView(appearance: appearance)
                let alertViewIcon = UIImage(named: "LogoWithBorder")
                askLocationAlertView.addButton("我知道了", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(self.dismissAlert))
                askLocationAlertView.showInfo("友情提示", subTitle: "请输入餐厅名称", colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
            } else {
                updateRestaurantInfoRequest.restaurantId = restaurant.id
                updateRestaurantInfoRequest.name = restaurantName
                DataAccessor(serviceConfiguration: ParseConfiguration()).updateRestaurantInfo(updateRestaurantInfoRequest, responseHandler: { (response) -> Void in
                    OperationQueue.main.addOperation({ () -> Void in
                        
                    })
                    
                })
                // We always display success no matter what the response is
                // because we don't want to block the UI when api call failed
                let appearance = SCLAlertView.SCLAppearance(kCircleIconHeight: 40.0, showCloseButton: false, showCircularIcon: true)
                let askLocationAlertView = SCLAlertView(appearance: appearance)
                let alertViewIcon = UIImage(named: "LogoWithBorder")
                askLocationAlertView.addButton("完成", backgroundColor: UIColor.themeOrange(), target:self, selector:#selector(self.dismissAlert))
                askLocationAlertView.showInfo("添加成功", subTitle: "成功更新餐厅名称", colorStyle: UIColor.themeOrange().getColorCode(), circleIconImage: alertViewIcon)
            }
        }
    }
    
    func dismissAlert() {
        
    }
    
    

}