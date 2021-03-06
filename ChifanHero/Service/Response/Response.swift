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
    var error: CFHError?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        result = Favorite(data: data["result"])
        error = CFHError(data: data["error"])
    }
}

class GetCitiesResponse: HttpResponseProtocol {

    var results: [City] = []
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = City(data: resultJson)
                results.append(result)
            }
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }

}

class GetFavoritesResponse: HttpResponseProtocol{

    var error: CFHError?
    var results: [Favorite] = []

    required init() {

    }

    required init(data: JSON) {
        error = CFHError(data: data["error"])
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
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
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
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Picture(data: resultJson)
                results.append(result)
            }
        }
    }

}

class GetIsFavoriteResponse: HttpResponseProtocol{
    var error: CFHError?
    var result: Bool?

    required init() {

    }

    required init(data: JSON) {
        error = CFHError(data: data["error"])
        result = data["result"].bool
    }
}

class GetRestaurantByIdResponse: HttpResponseProtocol{

    var result: Restaurant?
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["result"].exists() {
            result = Restaurant(data: data["result"])
        }
    }

}

class GetRestaurantCollectionMembersResponse: HttpResponseProtocol{

    var results: [Restaurant] = []
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = Restaurant(data: resultJson)
                results.append(result)
            }
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }

}

class GetRestaurantsResponse: HttpResponseProtocol {

    var results: [Restaurant] = [Restaurant]()
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
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
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["result"].exists() {
            result = Review(data: data["result"])
        }
    }

}

class GetAllReviewsOfOneRestaurantResponse: HttpResponseProtocol {

    var results: [Review] = []
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
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
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if let resultsJson = data["results"].array {
            for resultJson in resultsJson {
                let result = SelectedCollection(data: resultJson)
                results.append(result)
            }
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
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
        if data["user"].exists() {
            self.user = User(data: data["user"])
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class LogOutResponse: AccountResponse{

    required init() {
        super.init()
    }

    required init(data: JSON) {
        super.init()
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        success = data["success"].bool
    }
}

class NominateRestaurantResponse: HttpResponseProtocol{

    var result: Int?
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        result = data["result"]["count"].int
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
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
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        result = Favorite(data: data["result"])
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class UpsertReviewResponse: HttpResponseProtocol{

    var result: Review?
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["result"].exists() {
            result = Review(data: data["result"])
        }
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
        if data["user"].exists() {
            self.user = User(data: data["user"])
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }

}

class UpdateInfoResponse: AccountResponse{

    required init() {
        super.init()
    }

    required init(data: JSON) {
        super.init(data: data)
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["user"].exists() {
            user = User(data: data["user"])
        }
        success = data["success"].bool
    }
}

class UpdateRestaurantInfoResponse: HttpResponseProtocol{

    var result: Restaurant?
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["result"].exists() {
            result = Restaurant(data: data["result"])
        }
    }

}

class UploadPictureResponse: HttpResponseProtocol{

    var result: Picture?
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["result"].exists() {
            result = Picture(data: data["result"])
        }
    }
}

class DeletePicturesResponse: HttpResponseProtocol{
    
    var result: Any?
    var error: CFHError?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        result = data["result"].object
    }
}

class UploadRestaurantPictureResponse: HttpResponseProtocol{

    var result: Picture?
    var error: CFHError?

    required init() {

    }

    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        if data["result"].exists() {
            result = Picture(data: data["result"])
        }
    }
}

class AddRecommendDishResponse: HttpResponseProtocol {
    var result: RecommendedDish?
    var error: CFHError?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if data["result"].exists() {
            result = RecommendedDish(data: data["result"])
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class TrackRestaurantResponse: HttpResponseProtocol {
    var success: Bool?
    var error: CFHError?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        success = data["success"].bool
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class ChangePasswordResponse: AccountResponse {
    
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        self.success = data["success"].bool
        self.sessionToken = data["session_token"].string
    }
}

class ResetPasswordResponse: AccountResponse {
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        self.success = data["success"].bool
        self.sessionToken = data["session_token"].string
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class NewRandomUserResponse: AccountResponse {
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        self.success = data["success"].bool
        self.sessionToken = data["session_token"].string
        if data["user"].exists() {
            self.user = User(data: data["user"])
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class GetMyInfoResponse: AccountResponse {
    required init() {
        super.init()
    }
    
    required init(data: JSON) {
        super.init(data: data)
        if data["user"].exists() {
            self.user = User(data: data["user"])
        }
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
    }
}

class GetEmailVerifiedResponse: HttpResponseProtocol {
    var verified: Bool?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        verified = data["verified"].bool
    }
}

class GetAppVersionInfoResponse: HttpResponseProtocol{
    
    var isLatestVersion: Bool?
    var isMandatory: Bool?
    var latestVersion: String?
    var updateInfo: String?
    var error: CFHError?
    
    required init() {
        
    }
    
    required init(data: JSON) {
        if data["error"].exists() {
            error = CFHError(data: data["error"])
        }
        isLatestVersion = data["isLatestVersion"].bool
        isMandatory = data["isMandatory"].bool
        latestVersion = data["latestVersion"].string
        updateInfo = data["updateInfo"].string
    }
    
}
