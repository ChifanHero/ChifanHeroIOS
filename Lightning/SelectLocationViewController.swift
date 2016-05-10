//
//  SelectLocationViewController.swift
//  Lightning
//
//  Created by Shi Yan on 5/8/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SelectLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBOutlet weak var locationTable: UITableView!
    
    var cities : [City] = [City]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.tintColor = UIColor.whiteColor()
        doneButton.tintColor = UIColor.whiteColor()
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

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cities.count + 1
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : CityTableViewCell? = tableView.dequeueReusableCellWithIdentifier("cityCell") as? CityTableViewCell
        if cell == nil {
            tableView.registerNib(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "cityCell")
            cell = tableView.dequeueReusableCellWithIdentifier("cityCell") as? CityTableViewCell
        }
        cell?.cityName = "San Jose, CA, USA"
        return cell!
    }
    
}
