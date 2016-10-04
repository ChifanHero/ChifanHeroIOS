//
//  NewReviewViewController.swift
//  Lightning
//
//  Created by Shi Yan on 10/3/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class NewReviewViewController: UIViewController {
    
    
    @IBOutlet weak var bottomDistanceConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func submit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewReviewViewController.handleKeyboardDidShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func handleKeyboardDidShowNotification(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomDistanceConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }
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
