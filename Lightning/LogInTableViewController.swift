//
//  LogInTableViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 3/1/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class LogInTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var normalLoginButton: LoadingButton!
    var wechatLoginButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearTitleForBackBarButtonItem()

        if isLoggedIn(){
            replaceLoginViewByAboutMeView()
        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.configureLoginButton()
        
        var fbButton = FBSDKLoginButton(frame: CGRectMake(self.view.frame.width * 0.1, 250, self.view.frame.width * 0.8, 40))
        self.view.addSubview(fbButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackLoginView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureLoginButton(){
        wechatLoginButton = LoadingButton(frame: CGRectMake(self.view.frame.width * 0.1, 200, self.view.frame.width * 0.8, 40), color: UIColor(red: 68 / 255  , green: 176 / 255, blue: 53 / 255, alpha: 1.0))
        wechatLoginButton.setLogoImage(UIImage(named: "Wechat")!)
        wechatLoginButton.setTextContent("微信登录")
        self.view.addSubview(wechatLoginButton)
        wechatLoginButton.addTarget(self, action: #selector(LogInTableViewController.wechatLoginEvent), forControlEvents: UIControlEvents.TouchDown)
        
        normalLoginButton = LoadingButton(frame: CGRectMake(self.view.frame.width * 0.1, 150, self.view.frame.width * 0.8, 40), color: UIColor.themeOrange())
        normalLoginButton.setLogoImage(UIImage(named: "Cancel_Button")!)
        normalLoginButton.setTextContent("登录")
        self.view.addSubview(normalLoginButton)
        normalLoginButton.addTarget(self, action: #selector(LogInTableViewController.normalLoginEvent), forControlEvents: UIControlEvents.TouchDown)
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
                normalLoginEvent()
                return true
            } else {
                return false
            }
        }
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
        normalLoginEvent()
    }
    
    func normalLoginEvent() {
        logIn(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    func wechatLoginEvent(){
        print("btnEvent", terminator: "")
    }
    
    func logIn(username username: String?, password: String?) {
        
        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: username, password: password) { (response, user) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let seconds = 2.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    
                    self.normalLoginButton.stopLoading()
                    if response == nil {
                        self.showErrorMessage("登录失败", message: "网络错误")
                    } else {
                        if response!.success == true {
                            let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            defaults.setBool(true, forKey: "isLoggedIn")
                            self.replaceLoginViewByAboutMeView()
                        } else {
                            print("login failed")
                            self.showErrorMessage("登录失败", message: "用户名或密码错误")
                        }
                    }
                    
                })
                
            })
        }
    }
    
    private func showErrorMessage(title : String?, message : String?) {
        var title = title
        if title == nil {
            title = "输入错误"
        }
        SCLAlertView().showWarning(title!, subTitle: message!)
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
