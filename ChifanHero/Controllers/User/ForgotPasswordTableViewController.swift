//
//  ForgotPasswordTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/8/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ForgotPasswordTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    var sendButton: RetryButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        emailTextField.delegate = self
        self.configureButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func configureButton() {
        sendButton = RetryButton(frame: CGRect(x: self.view.frame.width * 0.1, y: 100, width: self.view.frame.width * 0.8, height: 40))
        sendButton!.setCountdown(enabled: true, seconds: 10)
        sendButton!.setNormalState(text: "发送", color: nil, size: nil, backgroundColor: nil)
        sendButton!.setWaitingState(text: "已发送。如未收到邮件请重新发送", color: nil, size: nil, backgroundColor: nil)
        sendButton!.touchDownEvent = {
            self.resetPassword()
        }
        self.view.addSubview(sendButton!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let email = textField.text {
            if EmailUtil.isValidEmail(email: email) {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    private func resetPassword() {
        if let email = emailTextField.text {
            if (EmailUtil.isValidEmail(email: email)) {
                let resetPasswordRequest: ResetPasswordRequest = ResetPasswordRequest()
                resetPasswordRequest.email = email
                AccountManager(serviceConfiguration: ParseConfiguration()).resetPassword(resetPasswordRequest, responseHandler: { (response) in
                    if response?.success != nil && response?.success == true {
                        self.sendButton?.startWaiting()
                    } else {
                        AlertUtil.showErrorAlert(errorCode: response?.error?.code)
                    }
                })
            }
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
