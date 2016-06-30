//
//  AcountManager.swift
//  Lightning
//
//  Created by Shi Yan on 10/4/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AccountManager {
    
    var serviceConfiguration : ServiceConfiguration
    
    let myKeyChainWrapper = KeychainWrapper()
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    func oauthLogin(oauthLogin oauthLogin: String?, responseHandler: (OauthLoginResponse?) -> Void) {
        
        let request: OauthLoginRequest = OauthLoginRequest()
        request.oauthLogin = oauthLogin
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let httpClient = HttpClient()
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var loginResponse: OauthLoginResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    loginResponse = OauthLoginResponse(data: jsonData)
                    if loginResponse != nil && loginResponse!.success == true && loginResponse!.user != nil {
                        //self.saveUser(loginResponse?.user, username: loginResponse?.user?.userName, password: "", sessionToken: loginResponse?.sessionToken)
                    }
                    
                } catch {
                    print(error)
                }
            }
            responseHandler(loginResponse!)
        }
        
    }
    
//    func logIn(username username: String?, password: String?, responseHandler: (LoginResponse?, User?) -> Void) {
//        
//        let request : LoginRequest = LoginRequest()
//        request.username = username
//        request.password = password
//        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
//        print(url)
//        
//        let httpClient = HttpClient()
//        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
//            var loginResponse : LoginResponse? = nil
//            if data != nil {
//                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                var jsonData : [String : AnyObject]
//                do {
//                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
//                    loginResponse = LoginResponse(data: jsonData)
//                    if loginResponse != nil && loginResponse!.success == true && loginResponse!.user != nil {
//                        self.saveUser(loginResponse?.user, username: username, password: password, sessionToken: loginResponse?.sessionToken)
//                    }
//                    
//                } catch {
//                    print(error)
//                }
//            }
//            responseHandler(loginResponse, loginResponse?.user)
//        }
//        
//    }
    
//    func signUp(username username: String, password: String, responseHandler: (SignUpResponse?) -> Void){
//        
//        let request : SignUpRequest = SignUpRequest()
//        request.username = username
//        request.password = password
//        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
//        print(url)
//        
//        let httpClient = HttpClient()
//        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
//            
//            var signUpResponse : SignUpResponse? = nil
//            if data != nil {
//                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                var jsonData : [String : AnyObject]
//                do {
//                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
//                    signUpResponse = SignUpResponse(data: jsonData)
//                    if signUpResponse?.success != nil && signUpResponse!.success! == true{
////                        self.logIn(username: username, password: password, responseHandler: { (success, user) -> Void in
////                        })
//                    }
//                    
//                } catch {
//                    print(error)
//                }
//                
//            }
//            responseHandler(signUpResponse)
//            
//        }
//    }
    
//    func updateInfo(nickName nickName: String?, pictureId: String?, responseHandler : (Bool?, User?) -> Void) {
//        
//        let request : UpdateInfoRequest = UpdateInfoRequest()
//        request.nickName = nickName
//        request.pictureId = pictureId
//        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
//        print(url)
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
//        let httpClient = HttpClient()
//        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
//            var updateInfoResponse: UpdateInfoResponse?
//            if data != nil {
//                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                var jsonData : [String : AnyObject]
//                do {
//                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
//                    updateInfoResponse = UpdateInfoResponse(data: jsonData)
//                    if updateInfoResponse != nil && updateInfoResponse?.success == true && updateInfoResponse?.user != nil {
//                        self.saveUser(nickName: updateInfoResponse!.user?.nickName, userPicURL: updateInfoResponse?.user?.picture?.original)
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//            
//            
//            responseHandler(updateInfoResponse?.success, updateInfoResponse?.user)
//        }
//        
//    }
    
//    func logOut(responseHandler responseHandler : (Bool?) -> Void) {
//        
//        let request : LogOutRequest = LogOutRequest()
//        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
//        print(url)
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
//        let httpClient = HttpClient()
//        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
//            var logOutResponse: LogOutResponse?
//            if data != nil {
//                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                var jsonData : [String : AnyObject]
//                do {
//                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
//                    logOutResponse = LogOutResponse(data: jsonData)
//                    if logOutResponse != nil && logOutResponse?.success == true {
//                        self.deleteUser()
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//            responseHandler(logOutResponse?.success)
//        }
//    }
    
//    private func saveUser(user: User?, username: String?, password: String?, sessionToken: String?) {
//        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        
//        defaults.setValue(sessionToken, forKey: "sessionToken")
//        
//        defaults.setValue(user!.id, forKey: "userId")
//        defaults.setValue(username, forKey: "username")
//        defaults.setObject(user!.nickName, forKey: "userNickName")
//        defaults.setValue(user!.picture?.thumbnail, forKey: "userPicURL")
//        defaults.synchronize()
//        myKeyChainWrapper.mySetObject(password, forKey: kSecValueData)
//        myKeyChainWrapper.writeToKeychain()
//    }
//    
//    private func saveUser(nickName nickName: String?, userPicURL: String?){
//        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(nickName, forKey: "userNickName")
//        defaults.setValue(userPicURL, forKey: "userPicURL")
//    }
//    
//    private func deleteUser(){
//        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        
//        defaults.setValue(nil, forKey: "sessionToken")
//        
//        defaults.setValue(nil, forKey: "userId")
//        defaults.setValue(nil, forKey: "username")
//        defaults.setObject(nil, forKey: "userNickName")
//        defaults.setValue(nil, forKey: "userPicURL")
//        defaults.synchronize()
//        myKeyChainWrapper.mySetObject(nil, forKey: kSecValueData)
//        myKeyChainWrapper.writeToKeychain()
//    }
    
    private func callApi<Response: HttpResponseProtocol>(request: HttpRequestProtocol, afterSuccess: (AccountResponse?, String?) -> Void, responseHandler: (Response?) -> Void){
        
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        Alamofire.request(.POST, url, parameters: request.getRequestBody(), encoding: .JSON, headers: request.getHeaders()).responseJSON { response in
            
            var responseObject: Response?
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    responseObject = Response(data: json.dictionaryObject!)
                    if response.response?.statusCode >= 200 && response.response?.statusCode < 300 {
                        afterSuccess(responseObject as? AccountResponse, (request as! AccountRequest).password)
                    }
                }
            case .Failure(let error):
                print(error)
            }
            
            responseHandler(responseObject)
        }
    }
    
    func signUp(username username: String, password: String, responseHandler: (SignUpResponse?) -> Void){
        
        let request: SignUpRequest = SignUpRequest()
        request.username = username
        request.password = password
        
        self.callApi(request, afterSuccess: self.loginAfterSignUp, responseHandler: responseHandler)
    }
    
    private func loginAfterSignUp(response: AccountResponse?, password: String?){
        self.logIn(username: response!.user?.userName, password: password, responseHandler: { (success) -> Void in})
    }
    
    func logIn(username username: String?, password: String?, responseHandler: (LoginResponse?) -> Void) {
        
        let request: LoginRequest = LoginRequest()
        request.username = username
        request.password = password
        
        self.callApi(request, afterSuccess: self.saveUser, responseHandler: responseHandler)
    }
    
    func updateInfo(nickName nickName: String?, pictureId: String?, responseHandler : (UpdateInfoResponse?) -> Void) {
        
        let request: UpdateInfoRequest = UpdateInfoRequest()
        request.nickName = nickName
        request.pictureId = pictureId
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        self.callApi(request, afterSuccess: self.updateUser, responseHandler: responseHandler)
    }
    
    func logOut(responseHandler responseHandler: (LogOutResponse?) -> Void) {
        
        let request: LogOutRequest = LogOutRequest()
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        self.callApi(request, afterSuccess: self.deleteUser, responseHandler: responseHandler)
    }
    
    private func saveUser(response: AccountResponse?, password: String?) {
        
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(response!.sessionToken, forKey: "sessionToken")
        defaults.setValue(response!.user?.id, forKey: "userId")
        defaults.setValue(response!.user?.userName, forKey: "username")
        defaults.setValue(response!.user?.nickName, forKey: "userNickName")
        defaults.setValue(response!.user?.picture?.thumbnail, forKey: "userPicURL")
        defaults.synchronize()
        if password != nil {
            myKeyChainWrapper.mySetObject(password, forKey: kSecValueData)
            myKeyChainWrapper.writeToKeychain()
        }
    }
    
    private func updateUser(response: AccountResponse?, password: String?) {
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(response!.user?.nickName, forKey: "userNickName")
        defaults.setValue(response!.user?.picture?.thumbnail, forKey: "userPicURL")
    }
    
    private func deleteUser(response: AccountResponse?, password: String?){
        let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setValue(nil, forKey: "sessionToken")
        defaults.setValue(nil, forKey: "userId")
        defaults.setValue(nil, forKey: "username")
        defaults.setValue(nil, forKey: "userNickName")
        defaults.setValue(nil, forKey: "userPicURL")
        defaults.synchronize()
        myKeyChainWrapper.mySetObject(nil, forKey: kSecValueData)
        myKeyChainWrapper.writeToKeychain()
    }
    
    
}
