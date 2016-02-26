//
//  AppChildViewController.swift
//  Lightning
//
//  Created by Shi Yan on 2/26/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class TutorialChildViewController: UIViewController {
    
    
    @IBOutlet weak var screenNumber: UILabel!
    var index : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenNumber.text = "Screen #\(index)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
