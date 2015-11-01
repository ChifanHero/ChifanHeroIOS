//
//  ListCandidateViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 11/1/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListCandidateViewController: UIViewController {
    
    
    @IBOutlet weak var mainView: ListCandidateTopView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.submitButton.addTarget(self, action: "submit", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submit() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
