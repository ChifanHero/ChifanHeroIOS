//
//  ListCandidateViewController.swift
//  SoHungry
//
//  Created by Shi Yan on 11/1/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import UIKit

class ListCandidateViewController: UIViewController {
    
    var memberIds : [String]?
    var currentListId : String?
    
    var memberViewController : ListMemberViewController?
    
    
    @IBOutlet weak var mainView: ListCandidateTopView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        mainView.submitButton.addTarget(self, action: "submit", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
        mainView.parentVC = self
        let context = ListCandidateContext()
        context.memberIds = self.memberIds
        mainView.context = context
        mainView.currentListId = currentListId
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func submit() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    @IBAction func cancel(sender: AnyObject) {
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

class ListCandidateContext {
    
    var memberIds : [String]?
}
