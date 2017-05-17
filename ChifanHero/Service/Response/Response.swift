//
//  Response.swift
//  Lightning
//
//  Created by Zhang, Alex on 12/7/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddToFavoritesResponse: HttpResponseProtocol{
    
    var result: Favorite?
    var error: Error?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        result = Favorite(data: data["result"])
        error = Error(data: data["error"])
    }
}

class GetCitiesResponse: HttpResponseProtocol {

    var results: [City] = []
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = City(data: resultJson)
                results.append(result)
            }
        }
        error = Error(data: data["error"])
    }

}

class GetFavoritesResponse: HttpResponseProtocol{

    var error: Error?
    var results: [Favorite] = []

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Favorite(data: resultJson)
                results.append(result)
            }
        }
    }
}

class GetHomepageResponse: HttpResponseProtocol {

    var results: [HomepageSection] = []
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["homepagesections"].array {
            for resultJson in resultsJson {
                let result = HomepageSection(data: resultJson)
                results.append(result)
            }
        }
    }

}

class GetImagesResponse: HttpResponseProtocol {

    var results: [Picture] = []
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson)
                results.append(result)
            }
        }
    }

}

class GetIsFavoriteResponse: HttpResponseProtocol{
    var error: Error?
    var result: Bool?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        result = data["result"].bool
    }
}

class GetRestaurantByIdResponse: HttpResponseProtocol{

    var result: Restaurant?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Restaurant(data: data["result"])
    }

}

class GetRestaurantCollectionMembersResponse: HttpResponseProtocol{

    var results: [Restaurant] = []
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                results.append(result)
            }
        }
        error = Error(data: data["error"])
    }

}

class GetRestaurantsResponse: HttpResponseProtocol {

    var results: [Restaurant] = [Restaurant]()
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                results.append(result)
            }
        }
    }

}

class GetReviewByIdResponse: HttpResponseProtocol{

    var result: Review?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Review(data: data["result"])
    }

}

class GetAllReviewsOfOneRestaurantResponse: HttpResponseProtocol {

    var results: [Review] = []
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Review(data: resultJson)
                results.append(result)
            }
        }
    }

}

class GetSelectedCollectionsByLatAndLonResponse: HttpResponseProtocol{

    var results: [SelectedCollection] = []
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = SelectedCollection(data: resultJson)
                results.append(result)
            }
        }
        error = Error(data: data["error"])
    }

}

class LoginResponse: AccountResponse {

    required init() {
        super.init()
    }

    required init(data: JSON) {
        super.init(data: data)
        self.success = data["success"].bool
        self.sessionToken = data["session_token"].string
        self.user = User(data: data["user"])
    }
}

class LogOutResponse: AccountResponse{

    required init() {
        super.init()
    }

    required init(data: JSON) {
        super.init()
        error = Error(data: data["error"])
        success = data["success"].bool
    }
}

class NominateRestaurantResponse: HttpResponseProtocol{

    var result: Int?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        result = data["result"]["count"].int
        error = Error(data: data["error"])
    }

}

class OauthLoginResponse: Model {

    var success: Bool?
    var sessionToken: String?
    var user: User?

    required init() {

    }

    required init(data: JSON) {
        success = data["success"].bool
        sessionToken = data["session_token"].string
        user = User(data: data["user"])
    }

}

class RemoveFavoriteResponse: HttpResponseProtocol{

    var result: Favorite?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        result = Favorite(data: data["result"])
        error = Error(data: data["error"])
    }
}

class ReviewResponse: HttpResponseProtocol{

    var result: Review?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        result = Review(data: data["result"])
        error = Error(data: data["error"])
    }
}

class SignUpResponse: AccountResponse {

    required init() {
        super.init()
    }

    required init(data: JSON) {
        super.init(data: data)
        success = data["success"].bool
        sessionToken = data["session_token"].string
        user = User(data: data["user"])
        error = Error(data: data["error"])
    }

}

class UpdateInfoResponse: AccountResponse{

    required init() {
        super.init()
    }

    required init(data: JSON) {
        super.init(data: data)
        error = Error(data: data["error"])
        user = User(data: data["user"])
        success = data["success"].bool
    }
}

class UpdateRestaurantInfoResponse: HttpResponseProtocol{

    var result: Restaurant?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Restaurant(data: data["result"])
    }

}

class UploadPictureResponse: HttpResponseProtocol{

    var result: Picture?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Picture(data: data["result"])
    }
}

class UploadRestaurantPictureResponse: HttpResponseProtocol{

    var result: Picture?
    var error: Error?

    required init() {

    }

    required init(data: JSON) {
        error = Error(data: data["error"])
        result = Picture(data: data["result"])
    }
}