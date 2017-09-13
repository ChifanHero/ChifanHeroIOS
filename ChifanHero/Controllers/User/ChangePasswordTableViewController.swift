//
//  ChangePasswordTableViewController.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/9/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    
    
    @IBOutlet weak var passwordHintsContainer: UIStackView!
    
    var isUsingDefaultPassword: Bool = false
    
    @IBOutlet weak var checkmarkImageOne: UIImageView!
    @IBOutlet weak var checkmarkImageTwo: UIImageView!
    @IBOutlet weak var checkmarkImageThree: UIImageView!
    @IBOutlet weak var checkmarkImageFour: UIImageView!
    
    // rule1: contains uppercase
    // rule2: contains lowercase
    // rule3: contains number
    // rule4: at least 8 characters
    var rule1 = false
    var rule2 = false
    var rule3 = false
    var rule4 = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        newPasswordConfirmationTextField.delegate = self
        passwordHintsContainer.isHidden = true
        
        newPasswordTextField.addTarget(self, action: #selector(ChangePasswordTableViewController.didChangeText(_:)), for: .editingChanged)
        
        let defaultPassword = getDefaultPassword()
        if (isUsingDefaultPassword && defaultPassword != nil) {
            oldPasswordTextField.isUserInteractionEnabled = false
            oldPasswordTextField.text = "您的系统生成密码为: " + defaultPassword! + "。 请尽快修改"
            oldPasswordTextField.isSecureTextEntry = false
        }
        
         configureCheckMarkImage()
    }
    
    private func configureCheckMarkImage(){
        self.view.layoutIfNeeded()
        checkmarkImageOne.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageOne.isHidden = true
        checkmarkImageTwo.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageTwo.isHidden = true
        checkmarkImageThree.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageThree.isHidden = true
        checkmarkImageFour.renderColorChangableImage(UIImage(named: "CheckMark.png")!, fillColor: UIColor.green)
        checkmarkImageFour.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPasswordTextField {
            passwordHintsContainer.isHidden = false
        } else {
            passwordHintsContainer.isHidden = true
        }
    }
    
    func didChangeText(_ textField:UITextField) {
        validatePassword(textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            textField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
            return true
        } else if textField == newPasswordTextField {
            if isValidPassword() {
                textField.resignFirstResponder()
                newPasswordConfirmationTextField.becomeFirstResponder()
                return true
            } else {
                return false
            }
        } else if textField == newPasswordConfirmationTextField {
            if oldPasswordTextField.text != nil && isValidPassword() && textField.text == newPasswordTextField.text {
                textField.resignFirstResponder()
                if isUsingDefaultPassword {
                    changePassword(oldPassword: getDefaultPassword(), newPassword: newPasswordTextField.text)
                } else {
                    changePassword(oldPassword: oldPasswordTextField.text, newPassword: newPasswordTextField.text)
                }
                
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    private func getDefaultPassword() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "defaultPassword")
    }
    
    private func isValidPassword() -> Bool {
        return rule1 && rule2 && rule3 && rule4
    }
    
    private func changePassword(oldPassword: String?, newPassword: String?) {
        AccountManager(serviceConfiguration: ParseConfiguration()).changePassword(oldPassword: oldPassword, newPassword: newPassword) { (response) in
            if let errorCode = response?.error?.code {
                AlertUtil.showErrorAlert(errorCode: errorCode, target: self, buttonAction: #selector(self.doNothing))
            } else if response?.success != nil && response?.success == true{
                AlertUtil.showAlertView(buttonText: "完成", infoTitle: "密码修改成功", infoSubTitle: "", target: self, buttonAction: #selector(self.doNothing))
            } else {
                AlertUtil.showAlertView(buttonText: "我知道了", infoTitle: "未知错误", infoSubTitle: "很抱歉给您带来不便，我们会尽快修复", target: self, buttonAction: #selector(self.doNothing))
            }
        }
    }
    
    func doNothing() {
        
    }
    
    private func validatePassword(_ password: String){
        // rule1: contains uppercase
        // rule2: contains lowercase
        // rule3: contains number
        // rule4: at least 8 characters
        
        do {
            var regex = try NSRegularExpression(pattern: "^(?=.*[A-Z])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            var count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageOne.isHidden = false
                rule1 = true
            } else {
                checkmarkImageOne.isHidden = true
                rule1 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.*[a-z])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageTwo.isHidden = false
                rule2 = true
            } else {
                checkmarkImageTwo.isHidden = true
                rule2 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.*[0-9])", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageThree.isHidden = false
                rule3 = true
            } else {
                checkmarkImageThree.isHidden = true
                rule3 = false
            }
            regex = try NSRegularExpression(pattern: "^(?=.{8,})", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            count = regex.numberOfMatches(in: password, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange())
            if count > 0 {
                checkmarkImageFour.isHidden = false
                rule4 = true
            } else {
                checkmarkImageFour.isHidden = true
                rule4 = false
            }
        } catch {
            print(error)
        }
        
    }

    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
