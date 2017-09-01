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
    var facebookLoginButton: LoadingButton!
    var quickSignupButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearTitleForBackBarButtonItem()

        if isLoggedIn(){
            self.replaceLoginViewByAboutMeView()
        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.configureNavigationController()
        self.configureLoginButton()
        self.addNotificationButton()
        self.addSignUpButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TrackingUtil.trackLoginView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addNotificationButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("消息", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(LogInTableViewController.showNotification), for: UIControlEvents.touchUpInside)
        let notificationButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = notificationButton
    }
    
    fileprivate func addSignUpButton() {
        let button: UIButton = ButtonUtil.barButtonWithTextAndBorder("注册", size: CGRect(x: 0, y: 0, width: 80, height: 26))
        button.addTarget(self, action: #selector(LogInTableViewController.showSignUp), for: UIControlEvents.touchUpInside)
        let signUpButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = signUpButton
    }
    
    func showNotification(){
        performSegue(withIdentifier: "showNotification", sender: nil)
    }
    
    func showSignUp(){
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    func configureLoginButton(){
//        wechatLoginButton = LoadingButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 250, width: self.view.frame.width * 0.8, height: 40), color: UIColor(red: 68 / 255  , green: 176 / 255, blue: 53 / 255, alpha: 1.0))
//        wechatLoginButton.setLogoImage(UIImage(named: "Wechat")!)
//        wechatLoginButton.setTextContent("微信登录")
//        wechatLoginButton.addTarget(self, action: #selector(LogInTableViewController.wechatLoginEvent), for: UIControlEvents.touchDown)
        //self.view.addSubview(wechatLoginButton)
        
//        facebookLoginButton = LoadingButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 200, width: self.view.frame.width * 0.8, height: 40), color: UIColor(red: 59 / 255  , green: 89 / 255, blue: 152 / 255, alpha: 1.0))
//        facebookLoginButton.setLogoImage(UIImage(named: "Facebook")!)
//        facebookLoginButton.setTextContent("Facebook Login")
//        facebookLoginButton.addTarget(self, action: #selector(getter: LogInTableViewController.facebookLoginButton), for: UIControlEvents.touchDown)
        //self.view.addSubview(facebookLoginButton)
        
        quickSignupButton = LoadingButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 200, width: self.view.frame.width * 0.8, height: 40), color: UIColor.themeOrange(), textContent: "一键获取临时用户")
        quickSignupButton.addTarget(self, action: #selector(LogInTableViewController.quickSignUpEvent), for: UIControlEvents.touchDown)
        self.view.addSubview(quickSignupButton)
        
        normalLoginButton = LoadingButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 150, width: self.view.frame.width * 0.8, height: 40), color: UIColor.themeOrange(), logoImage: UIImage(named: "LogoWithBorder")!, textContent: "登录")
        self.view.addSubview(normalLoginButton)
        normalLoginButton.addTarget(self, action: #selector(LogInTableViewController.normalLoginEvent), for: UIControlEvents.touchDown)
        
        
        
        //let fbButton = FBSDKLoginButton(frame: CGRectMake(self.view.frame.width * 0.1, 250, self.view.frame.width * 0.8, 40))
        //fbButton.readPermissions = ["public_profile", "email"]
        //self.view.addSubview(fbButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if let username = textField.text {
                if username.characters.count > 0 && username.contains("@") == true{
                    textField.resignFirstResponder()
                    passwordTextField.becomeFirstResponder()
                    return true
                } else {
                    return false
                }
            }
        } else {
            if let password = textField.text {
                if password.characters.count > 0{
                    normalLoginEvent()
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func isLoggedIn() -> Bool{
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.bool(forKey: "isLoggedIn")
    }
    
    func replaceLoginViewByAboutMeView() {
        let tabBarController : UITabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        var viewControllers = tabBarController.viewControllers!
        for index in 0 ..< viewControllers.count {
            let vc : UIViewController = viewControllers[index]
            if vc.restorationIdentifier == "LogInNavigationController" {
                viewControllers.remove(at: index)
                let aboutMeNC = getAboutMeNavigationController()
                viewControllers.insert(aboutMeNC, at: index)
                break
            }
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    private func getAboutMeNavigationController() -> UINavigationController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "User", bundle: nil)
        let aboutMeNC : UINavigationController = storyBoard.instantiateViewController(withIdentifier: "AboutMeNavigationController") as! UINavigationController
        aboutMeNC.tabBarItem = UITabBarItem(title: "个人", image: UIImage(named: "Me_Tab"), tag: 4)
        return aboutMeNC
    }
    
    func normalLoginEvent() {
        logIn(username: usernameTextField.text, password: passwordTextField.text)
    }
    
    func quickSignUpEvent() {
        quickSignUp()
    }
    
    /*func facebookLoginEvent() {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: {(result, error) -> Void in
            if error != nil {
                print(error)
            } else if (result?.isCancelled)! {
                print("Canceled")
            } else {
                FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "id, name, email"]).start(completionHandler: {
                    (connection, result, error: NSError!) -> Void in
                    if error == nil {
                        
                        let email = result["email"] as! String
                        AccountManager(serviceConfiguration: ParseConfiguration()).oauthLogin(oauthLogin: email) { (response) -> Void in
                            OperationQueue.main.addOperation({ () -> Void in
                                let seconds = 1.0
                                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                                let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                                
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    
                                    if response == nil {
                                        self.showErrorMessage("登录失败", message: "网络错误")
                                    } else {
                                        if response!.success == true {
                                            let defaults: UserDefaults = UserDefaults.standard
                                            defaults.set(true, forKey: "isLoggedIn")
                                            self.replaceLoginViewByAboutMeView()
                                        } else {
                                            print("login failed")
                                            self.showErrorMessage("登录失败", message: "用户名或密码错误")
                                        }
                                    }
                                    
                                })
                                
                            })
                        }
                    } else {
                        print("\(error)")
                    }
                })
            }
        })
    }*/
    
    func wechatLoginEvent() {
        
    }
    
    func logIn(username: String?, password: String?) {
        
        AccountManager(serviceConfiguration: ParseConfiguration()).logIn(username: username, password: password) { (response) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                let seconds = 2.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    
                    self.normalLoginButton.stopLoading()
                    if response == nil {
                        self.showErrorMessage(title: "登录失败", subTitle: "网络错误")
                    } else {
                        if response!.success != nil && response!.success! == true {
                            let defaults: UserDefaults = UserDefaults.standard
                            defaults.set(true, forKey: "isLoggedIn")
                            self.replaceLoginViewByAboutMeView()
                        } else {
                            self.showErrorMessage(title: "登录失败", subTitle: "用户名或密码错误")
                        }
                    }
                    
                })
                
            })
        }
    }

    func quickSignUp() {
        self.replaceLoginViewByAboutMeView()
    }
    
    func showErrorMessage(title: String, subTitle: String) {
        AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: title, infoSubTitle: subTitle, target: self, buttonAction: #selector(dismissAlert))
    }
    
    func dismissAlert() {
        
    }
    
    func resetLogInInput(_ alertAction: UIAlertAction!){
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "signUp"){
            let signUpTableViewController: SignUpTableViewController = segue.destination as! SignUpTableViewController
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
