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
    
    private func addCancelButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("取消", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func addDoneButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("提交", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(submit), for: UIControlEvents.touchUpInside)
        let doneButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func cancel() {
        self.goBack()
    }
    
    func submit() {
        if let dishName = recommendedDishTextField.text {
            if dishName.isEmpty {
                AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "友情提示", infoSubTitle: "请输入菜名", target: self, buttonAction: #selector(dismissAlert))
            } else {
                addRecommendedDishRequest.restaurantId = restaurant.id
                addRecommendedDishRequest.dishName = dishName
                DataAccessor(serviceConfiguration: ParseConfiguration()).addRecommendedDish(addRecommendedDishRequest, responseHandler: { (response) -> Void in
                    OperationQueue.main.addOperation({ () -> Void in
                        
                    })
                    
                })
                // We always display success no matter what the response is
                // because we don't want to block the UI when api call failed
                AlertUtil.showAlertView(buttonText: "完成", infoTitle: "推荐成功", infoSubTitle: "感谢您的推荐！", target: self, buttonAction: #selector(updateParentRestaurantAndGoBack))
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
    
    func dismissAlert() {
        
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
