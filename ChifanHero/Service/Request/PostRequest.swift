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

class RecommendDishRequest: HttpRequest{

    var restaurantId: String?
    var dishName: String?
    var dishId: String?
    var photos: [String] = []

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["restaurant_id"] = restaurantId as AnyObject
        parameters["dish_name"] = dishName as AnyObject
        parameters["dish_id"] = dishId as AnyObject
        parameters["photos"] = photos as AnyObject
        return parameters
    }

    override func getRelativeURL() -> String {
        return "/dishRecommendations"
    }
}

class ReviewRequest: HttpRequest{

    var content: String?
    var rating: Int?
    var restaurantId: String?
    var photos: [String]?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        parameters["content"] = content as AnyObject
        parameters["rating"] = rating as AnyObject
        parameters["restaurant_id"] = restaurantId as AnyObject
        parameters["photos"] = photos as AnyObject
        return parameters
    }

    override func getRelativeURL() -> String {
        return "/reviews"
    }
}

class UpdateInfoRequest: AccountRequest{

    var nickName: String?
    var pictureId: String?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["nick_name"] = nickName
        parameters["pictureId"] = pictureId
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/users/update"
    }
}

class UploadPictureRequest: HttpRequest{

    var restaurantId: String?
    var reviewId: String?
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
        parameters["base64_code"] = base64_code
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/images"
    }
}

class UploadRestaurantPictureRequest: HttpRequest{

    var restaurantId: String
    var type: String
    var base64_code: String
    var eventId: String?

    init(restaurantId: String, type: String, base64_code: String){
        self.restaurantId = restaurantId
        self.type = type
        self.base64_code = base64_code
    }

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, String>()
        parameters["restaurant_id"] = restaurantId
        parameters["type"] = type
        parameters["base64_code"] = base64_code
        parameters["event_id"] = eventId
        return parameters as [String : AnyObject]
    }

    override func getRelativeURL() -> String {
        return "/images"
    }
}
