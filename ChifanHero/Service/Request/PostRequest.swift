//
//  PostRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/7/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class AddToFavoritesRequest: HttpRequest{
    
    var type: String?
    var objectId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["type"] = type
        parameters["object_id"] = objectId
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/favorites"
    }
}


class SignUpRequest: AccountRequest {

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/users/signUp"
    }
}

class LoginRequest: AccountRequest {

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["username"] = username
        parameters["password"] = password
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/users/logIn"
    }
}

class LogOutRequest: AccountRequest{

    override func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/users/logOut"
    }
}

class OauthLoginRequest: AccountRequest {

    var oauthLogin: String?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["oauth_login"] = oauthLogin
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/users/oauthLogin"
    }
}

class AddRecommendDishRequest: HttpRequest{

    var restaurantId: String!
    var dishName: String?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["name"] = dishName as AnyObject
        return parameters
    }

    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId + "/recommendedDishes"
    }
}

class CreateReviewRequest: HttpRequest{

    var content: String?
    var rating: Int?
    var restaurantId: String!

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["content"] = content as AnyObject
        parameters["rating"] = rating as AnyObject
        return parameters
    }

    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId + "/reviews"
    }
}

class UpdateReviewRequest: HttpRequest{
    
    var content: String?
    var rating: Int?
    var reviewId: String!
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["content"] = content as AnyObject
        parameters["rating"] = rating as AnyObject
        return parameters
    }
    
    override func getRelativeURL() -> String {
        return "/reviews/" + reviewId
    }
}

class UpdateInfoRequest: AccountRequest{

    var nickName: String?
    var pictureId: String?
    var email: String?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["nick_name"] = nickName
        parameters["picture_id"] = pictureId
        parameters["email"] = email
        parameters["username"] = self.username
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/users/update"
    }
}

class UploadPictureRequest: HttpRequest{

    var restaurantId: String?
    var reviewId: String?
    var type: String?
    var base64_code: String

    init(base64_code: String){
        self.base64_code = base64_code
    }

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        if restaurantId != nil {
            parameters["restaurant_id"] = restaurantId
        }
        if reviewId != nil {
            parameters["review_id"] = reviewId
        }
        if type != nil {
            parameters["type"] = type
        }
        parameters["base64_code"] = base64_code
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/images"
    }
}

class UpdateRestaurantInfoRequest: HttpRequest{
    
    var restaurantId: String?
    var name: String?
    var blacklisted: Bool?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["name"] = name as AnyObject
        parameters["blacklisted"] = blacklisted as AnyObject
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId!
    }
}

class TrackRestaurantRequest: HttpRequest{
    
    var restaurantId: String?
    var userId: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["restaurantId"] = restaurantId
        parameters["userIdentifier"] = userId
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/track"
    }
}

class ChangePasswordRequest: HttpRequest {
    
    var oldPassword: String?
    var newPassword: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["old_password"] = oldPassword
        parameters["new_password"] = newPassword
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/users/changePassword"
    }
}


class ResetPasswordRequest: HttpRequest {
    
    var email: String?
    
    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["email"] = email
        return parameters as [String : AnyObject]
    }
    
    override func getRelativeURL() -> String {
        return "/users/resetPassword"
    }
}
