//
//  SignUpTableViewController.swift
//  Lightning
//
//  Created by Zhang, Alex on 2/29/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController, UITextFieldDelegate {

    var loginViewController: LogInTableViewController?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do additional setup after loading the view.
        UISetup()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self

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
    
    private func UISetup(){
        createButton.layer.cornerRadius = 5
    }
    
    @IBAction func createButtonTouched(sender: AnyObject) {
        createAccount()
    }
    
    private func createAccount() {
        AccountManager(serviceConfiguration: ParseConfiguration()).signUp(username: usernameTextField.text!, password: passwordTextField.text!){(success) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if success == true {
                    self.loginViewController?.replaceLoginViewByAboutMeView()
                    self.navigationController?.popViewControllerAnimated(true)
                } else{
                    print("fail")
                }
            });
            
        }
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
                createAccount()
                return true
            } else {
                return false
            }
        }
    }
    
    private func showErrorMessage() {
        let alert = UIAlertController(title: "输入错误", message: "请输入有效用户名和密码", preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "知道了", style: .Default, handler: self.resetLogInInput)
        alert.addAction(dismissAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetLogInInput(alertAction: UIAlertAction!){
        //currentLoginView?.getAccountTextField()!.text = nil
        //currentLoginView?.getPasswordTextField()!.text = nil
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
