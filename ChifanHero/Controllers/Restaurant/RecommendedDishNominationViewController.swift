//
//  CreateRecommendationViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class RecommendedDishNominationViewController: UIViewController {
    
    @IBOutlet weak var recommendedDishTextField: UITextField!
    
    let addRecommendedDishRequest: AddRecommendDishRequest! = AddRecommendDishRequest()
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCancelButton()
        self.addDoneButton()
    }
    
    func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("提交", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(submit), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancel() {
        self.goBack()
    }
    
    func submit() {
        if let dishName = recommendedDishTextField.text {
            if dishName.isEmpty {
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("知道了", target:self, selector:#selector(self.doNothing))
                alertView.showInfo("请输入菜名", subTitle: "请输入菜名全称")
            } else {
                addRecommendedDishRequest.restaurantId = restaurant.id
                addRecommendedDishRequest.dishName = dishName
                DataAccessor(serviceConfiguration: ParseConfiguration()).addRecommendedDish(addRecommendedDishRequest, responseHandler: { (response) -> Void in
                    OperationQueue.main.addOperation({ () -> Void in
                        
                    })
                    
                })
                // We always display success no matter what the response is
                // because we don't want to block the UI when api call failed
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("完成", target:self, selector:#selector(self.updateParentRestaurantAndGoBack))
                alertView.showSuccess("推荐成功", subTitle: "感谢您的推荐!")
            }
        }
    }
    
    func updateParentRestaurantAndGoBack() {
        self.mergeNewRecommendedDish(recommendedDishTextField.text!)
        self.goBack()
    }
    
    private func goBack() {
        self.performSegue(withIdentifier: "unwindToRecommendedDish", sender: self)
    }
    
    func doNothing() {
        
    }
    
    func mergeNewRecommendedDish(_ name: String) {
        for recommendedDish in self.restaurant.recommendedDishes {
            if recommendedDish.name == name {
                recommendedDish.recommendationCount! += 1
                return
            }
        }
        let newRecommendedDish = RecommendedDish()
        newRecommendedDish.name = name
        newRecommendedDish.recommendationCount = 1
        self.restaurant.recommendedDishes.append(newRecommendedDish)
    }
}
