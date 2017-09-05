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
    
    /*func oauthLogin(oauthLogin: String?, responseHandler: @escaping (OauthLoginResponse?) -> Void) {
        
        let request: OauthLoginRequest = OauthLoginRequest()
        request.oauthLogin = oauthLogin
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let httpClient = HttpClient()
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var loginResponse: OauthLoginResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try JSONSerialization.jsonObject(with: (strData?.data(using: String.Encoding.utf8.rawValue)!)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String : AnyObject]
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
        
    }*/
    
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
    
    private func callApi<Response: HttpResponseProtocol>(_ request: HttpRequestProtocol, afterSuccess: @escaping (AccountResponse) -> Void, responseHandler: @escaping (Response?) -> Void){
        
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        log.debug("POST \(url)")
        
        Alamofire.request(url, method: .post, parameters: request.getRequestBody(), encoding: JSONEncoding.default, headers: request.getHeaders()).responseJSON { response in
            
            var responseObject: Response?
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    responseObject = Response(data: json)
                    if (response.response?.statusCode)! >= 200 && (response.response?.statusCode)! < 300 {
                        afterSuccess(responseObject as! AccountResponse)
                    }
                }
            case .failure(let error):
                log.debug(error)
            }
            
            responseHandler(responseObject)
        }
    }
    
    func signUp(username: String, password: String, responseHandler: @escaping (SignUpResponse?) -> Void){
        
        let request = SignUpRequest()
        request.username = username
        request.password = password
        
        self.callApi(request, afterSuccess: self.saveUser, responseHandler: responseHandler)
    }
    
    func logIn(username: String?, password: String?, responseHandler: @escaping (LoginResponse?) -> Void) {
        
        let request = LoginRequest()
        request.username = username
        request.password = password
        
        self.callApi(request, afterSuccess: self.saveUser, responseHandler: responseHandler)
    }
    
    func updateInfo(nickName: String?, pictureId: String?, responseHandler : @escaping (UpdateInfoResponse?) -> Void) {
        self.updateInfo(nickName: nickName, pictureId: pictureId, email: nil, username: nil, responseHandler: responseHandler)
    }
    
    func updateInfo(nickName: String?, pictureId: String?, email: String?, username: String?, responseHandler : @escaping (UpdateInfoResponse?) -> Void) {
        
        let request: UpdateInfoRequest = UpdateInfoRequest()
        request.nickName = nickName
        request.pictureId = pictureId
        request.email = email
        request.username = username
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        self.callApi(request, afterSuccess: self.updateUser, responseHandler: responseHandler)
    }
    
    func logOut(responseHandler: @escaping (LogOutResponse?) -> Void) {
        
        let request: LogOutRequest = LogOutRequest()
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        defaults.set(nil, forKey: "sessionToken")
        self.callApi(request, afterSuccess: self.deleteUser, responseHandler: responseHandler)
    }
    
    func changePassword(oldPassword: String?, newPassword: String?, responseHandler: @escaping (ChangePasswordResponse?) -> Void) {
        let request: ChangePasswordRequest = ChangePasswordRequest()
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        self.callApi(request, afterSuccess: self.saveUser, responseHandler: responseHandler)
    }
    
    func getNewRandomUser(responseHandler: @escaping (NewRandomUserResponse?) -> Void) {
        let request: NewRandomUserRequest = NewRandomUserRequest()
        self.callApi(request, afterSuccess: self.saveUser, responseHandler: responseHandler)
    }
    
    private func saveUser(_ response: AccountResponse?) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(response!.sessionToken, forKey: "sessionToken")
    }
    
    private func updateUser(_ response: AccountResponse?) {
        
    }
    
    private func deleteUser(_ response: AccountResponse?){
        
    }
    
    
}
