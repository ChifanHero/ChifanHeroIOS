//
//  AcountManager.swift
//  SoHungry
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation


class AccountManager {
    
    var serviceConfiguration : ServiceConfiguration
    
    let myKenChainWrapper = KeychainWrapper()
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    static func isLoggedIn() -> Bool {
        return false
    }
    
    func logIn(username username : String?, password : String?, responseHandler : (Bool?, User?) -> Void) {
        let httpClient = HttpClient()
        let request : LoginRequest = LoginRequest()
        request.username = username
        request.password = password
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var loginResponse : LoginResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    loginResponse = LoginResponse(data: jsonData)
                    if loginResponse != nil && loginResponse!.success == true && loginResponse!.user != nil {
                        self.saveUser(username: username, userId :loginResponse?.user?.id, password: password, sessionToken: loginResponse?.sessionToken)
                    }
                    
                } catch {
                    print(error)
                }
            }
            responseHandler(loginResponse?.success, loginResponse?.user)
        }
        
    }
    
    private func saveUser(username username : String?, userId : String?, password : String?, sessionToken : String?) {
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(username, forKey: "username")
        defaults.setValue(sessionToken, forKey: "sessionToken")
        defaults.setValue(userId, forKey: "userId")
        defaults.synchronize()
        myKenChainWrapper.mySetObject(password, forKey: kSecValueData)
        myKenChainWrapper.writeToKeychain()
    }
    
    func signUp(username username : String, password : String) {
        
    }
    
    func logOut() {
        
    }
}
