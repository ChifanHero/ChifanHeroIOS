//
//  LogInTableViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class LogInTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    var logInIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearTitleForBackBarButtonItem()
        UISetup()

        if isLoggedIn(){
            replaceLoginViewByAboutMeView()
        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func UISetup() {
        self.signInButton.layer.cornerRadius = 5
        self.signInButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            let username = textField.text
            if username?.characters.count > 0 && username?.containsString("@") == true{
                textField.resignFirstResponder()
                passwordTextField.becomeFirstResponder()
                return true
            } else {
                return false
            }
        } else {
            let password = textField.text
            if password?.characters.count > 0{
                startLogIn()
                return true
            } else {
                return false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func clearTitleForBackBarButtonItem(){
        let barButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButtonItem
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
        for index in 0 ..< viewControllers.count {
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
        aboutMeNC.tabBarItem = UITabBarItem(title: "我的主页", image: UIImage(named: "AboutMe"), tag: 3)
        return aboutMeNC
    }
    
    @IBAction func signUpButtonTouched(sender: AnyObject) {
        performSegueWithIdentifier("signUp", sender: nil)
    }
    
    @IBAction func logInButtonTouched(sender: AnyObject) {
        startLogIn()
    }
    
    private func startLogIn() {
        logInIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        logInIndicator?.color = UIColor.grayColor()
        self.view.addSubview(logInIndicator!)
        centerIndicator()
        logInIndicator?.startAnimating()
        logIn(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    private func centerIndicator() {
//        let midXConstraint : NSLayoutConstraint = NSLayoutConstraint(item: self.logInIndicator!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute:NSLayoutAttribute.CenterX, multiplier: 1, constant: 0);
//        let midYConstraint : NSLayoutConstraint = NSLayoutConstraint(item: self.logInIndicator!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute:NSLayoutAttribute.CenterY, multiplier: 1, constant: 0);
//        self.view.addConstraints([midXConstraint, midYConstraint])
//        self.view.layoutIfNeeded()
        logInIndicator?.center = self.view.center
    }
    
    func logIn(username username: String?, password: String?) {
        self.signInButton.enabled = false
        
        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: username, password: password) { (response, user) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if response == nil {
                    self.showErrorMessage("登录失败", message: "网络错误")
                } else {
                    if response!.success == true {
                        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        defaults.setBool(true, forKey: "isLoggedIn")
                        self.replaceLoginViewByAboutMeView()
                    } else {
                        print("login failed")
                        self.showErrorMessage("登录失败", message: "用户名或密码错误")
                    }
                }
                self.logInIndicator?.stopAnimating()
                self.logInIndicator?.removeFromSuperview()
                self.signInButton.enabled = true
            })
        }
    }
    
    private func showErrorMessage(title : String?, message : String?) {
        var title = title
//        let alert = UIAlertController(title: "输入错误", message: "请输入有效用户名和密码", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let dismissAction = UIAlertAction(title: "知道了", style: .Default, handler: self.resetLogInInput)
//        alert.addAction(dismissAction)
//        
//        self.presentViewController(alert, animated: true, completion: nil)
        if title == nil {
            title = "输入错误"
        }
        let alertview = JSSAlertView().show(self, title: title!, text: message, buttonText: "我知道了")
        alertview.setTextTheme(.Dark)
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
