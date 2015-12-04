//
//  AcountManager.swift
//  Lightning
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class AccountManager {
    
    var serviceConfiguration : ServiceConfiguration
    
    let myKeyChainWrapper = KeychainWrapper()
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    func logIn(username username: String?, password: String?, responseHandler: (Bool?, User?) -> Void) {
        
        let request : LoginRequest = LoginRequest()
        request.username = username
        request.password = password
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let httpClient = HttpClient()
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var loginResponse : LoginResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    loginResponse = LoginResponse(data: jsonData)
                    if loginResponse != nil && loginResponse!.success == true && loginResponse!.user != nil {
                        self.saveUser(loginResponse?.user, username: username, password: password, sessionToken: loginResponse?.sessionToken)
                    }
                    
                } catch {
                    print(error)
                }
            }
            responseHandler(loginResponse?.success, loginResponse?.user)
        }
        
    }
    
    func signUp(username username: String, password: String, responseHandler: (Bool?) -> Void){
        
        let request : SignUpRequest = SignUpRequest()
        request.username = username
        request.password = password
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let httpClient = HttpClient()
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            
            var signUpResponse : SignUpResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    signUpResponse = SignUpResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            
            self.logIn(username: username, password: password){_,_ in
                
            }
            responseHandler(signUpResponse?.success)
        }
    }
    
    func updateInfo(nickName nickName: String?, pictureId: String?, responseHandler : (Bool?, User?) -> Void) {
        
        let request : UpdateInfoRequest = UpdateInfoRequest()
        request.nickName = nickName
        request.pictureId = pictureId
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        let httpClient = HttpClient()
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var updateInfoResponse: UpdateInfoResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    updateInfoResponse = UpdateInfoResponse(data: jsonData)
                    if updateInfoResponse != nil && updateInfoResponse?.success == true && updateInfoResponse?.user != nil {
                        self.saveUser(nickName: updateInfoResponse!.user?.nickName, userPicURL: updateInfoResponse?.user?.picture?.original)
                    }
                } catch {
                    print(error)
                }
            }
            
            
            responseHandler(updateInfoResponse?.success, updateInfoResponse?.user)
        }
        
    }
    
    func logOut(responseHandler responseHandler : (Bool?) -> Void) {
        
        let request : LogOutRequest = LogOutRequest()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        let httpClient = HttpClient()
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var logOutResponse: LogOutResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    logOutResponse = LogOutResponse(data: jsonData)
                    if logOutResponse != nil && logOutResponse?.success == true {
                        self.deleteUser()
                    }
                } catch {
                    print(error)
                }
            }
            responseHandler(logOutResponse?.success)
        }
    }
    
    private func saveUser(user: User?, username: String?, password: String?, sessionToken: String?) {
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(sessionToken, forKey: "sessionToken")
        
        defaults.setValue(user!.id, forKey: "userId")
        defaults.setValue(username, forKey: "username")
        defaults.setObject(user!.nickName, forKey: "userNickName")
        defaults.setValue(user!.picture?.thumbnail, forKey: "userPicURL")
        defaults.synchronize()
        myKeyChainWrapper.mySetObject(password, forKey: kSecValueData)
        myKeyChainWrapper.writeToKeychain()
    }
    
    private func saveUser(nickName nickName: String?, userPicURL: String?){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nickName, forKey: "userNickName")
        defaults.setValue(userPicURL, forKey: "userPicURL")
    }
    
    private func deleteUser(){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(nil, forKey: "sessionToken")
        
        defaults.setValue(nil, forKey: "userId")
        defaults.setValue(nil, forKey: "username")
        defaults.setObject(nil, forKey: "userNickName")
        defaults.setValue(nil, forKey: "userPicURL")
        defaults.synchronize()
        myKeyChainWrapper.mySetObject(nil, forKey: kSecValueData)
        myKeyChainWrapper.writeToKeychain()
    }
}
