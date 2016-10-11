//
//  CreateRecommendationViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/10/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class CreateRecommendationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addCancelButton()
        addDoneButton()
        // Do any additional setup after loading the view.
    }
    
    func addCancelButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("取消", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(CreateRecommendationViewController.cancel), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addDoneButton() {
        let button: UIButton = UIButton.barButtonWithTextAndBorder("提交", size: CGRectMake(0, 0, 80, 26))
        button.addTarget(self, action: #selector(CreateRecommendationViewController.submit), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func submit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
