//
//  LogInTableViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class LogInTableViewController: UITableViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var logInIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoggedIn(){
            replaceLoginViewByAboutMeView()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func isLoggedIn() -> Bool{
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let result: Bool? = defaults.boolForKey("isLoggedIn"){
            return result!
        } else{
            return false
        }
    }
    
    func replaceLoginViewByAboutMeView() {
        let tabBarController : UITabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for var index = 0; index < viewControllers.count; index++ {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "LogInNavigationController" {
                viewControllers.removeAtIndex(index)
                let aboutMeNC = getAboutMeNavigationController()
                viewControllers.insert(aboutMeNC, atIndex: index)
                break
            }
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    private func getAboutMeNavigationController() -> UINavigationController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutMeNC : UINavigationController = storyBoard.instantiateViewControllerWithIdentifier("AboutMeNavigationController") as! UINavigationController
        aboutMeNC.tabBarItem = UITabBarItem(title: "About me", image: UIImage(named: "about me"), tag: 3)
        return aboutMeNC
    }
    
    @IBAction func signUpButtonTouched(sender: AnyObject) {
        performSegueWithIdentifier("signUp", sender: nil)
    }
    
    @IBAction func logInButtonTouched(sender: AnyObject) {
        startLogIn()
    }
    
    private func startLogIn() {
        logInIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        logInIndicator!.center = self.view.center
        logIn(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    func logIn(username username: String?, password: String?) {
        
        logInIndicator?.startAnimating()
        self.view.addSubview(logInIndicator!)
        
        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: username, password: password) { (success, user) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if success == true {
                    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "isLoggedIn")
                    self.replaceLoginViewByAboutMeView()
                } else {
                    print("login failed")
                    self.logInIndicator?.stopAnimating()
                    self.logInIndicator?.removeFromSuperview()
                    self.showErrorMessage()
                }
            })
        }
    }
    
    private func showErrorMessage() {
        let alert = UIAlertController(title: "输入错误", message: "请输入有效用户名和密码", preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "知道了", style: .Default, handler: self.resetLogInInput)
        alert.addAction(dismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetLogInInput(alertAction: UIAlertAction!){
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "signUp"){
            let signUpTableViewController: SignUpTableViewController = segue.destinationViewController as! SignUpTableViewController
            signUpTableViewController.loginViewController = self;
        }
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
