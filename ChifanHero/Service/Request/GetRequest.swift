//
//  GetRequest.swift
//  Lightning
//
//  Created by Shi Yan on 5/17/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation

class GetCitiesRequest: HttpRequest {
    
    var prefix: String = ""

    override func getRelativeURL() -> String {
        return "/cities?prefix=" + prefix.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

class GetHotCitiesRequest: HttpRequest {

    override func getRelativeURL() -> String {
        return "/hotCities"
    }
}

class GetFavoritesRequest: HttpRequest{

    var favoriteType: String
    var lat: Double?
    var lon: Double?

    init(type: FavoriteTypeEnum){
        if type == FavoriteTypeEnum.restaurant{
            self.favoriteType = "restaurant"
        } else if type == .dish {
            self.favoriteType = "dish"
        } else {
            self.favoriteType = "selected_collection"
        }
    }

    override func getRelativeURL() -> String {
        var url = "/favorites?type=" + favoriteType
        if lat != nil && lon != nil {
            url = url + "&lat=\(lat!)&lon=\(lon!)"
        }
        return url
    }
}

class GetHomepageRequest: HttpRequest{

    var userLocation: Location?

    override init() {
    }

    override func getRelativeURL() -> String {
        return "/homepages?lat=" + String((userLocation?.lat)!) + "&lon=" + String((userLocation?.lon)!)
    }
}

class GetImagesRequest: HttpRequest {

    var restaurantId: String

    init(restaurantId: String) {
        self.restaurantId = restaurantId
    }

    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId + "/images"
    }
}

class GetIsFavoriteRequest: HttpRequest{

    var favoriteType: String
    var id: String

    init(type: FavoriteTypeEnum, id: String){
        if type == FavoriteTypeEnum.restaurant{
            self.favoriteType = "restaurant"
        } else if type == .dish {
            self.favoriteType = "dish"
        } else {
            self.favoriteType = "selected_collection"
        }
        self.id = id
    }

    override func getRelativeURL() -> String {
        return "/isFavorite?type=" + favoriteType + "&id=" + id
    }
}

class GetRestaurantByIdRequest: HttpRequest{

    var resourceId: String
    var userLocation: Location?

    init(id: String) {
        resourceId = id
    }

    func getResourceId() -> String {
        return resourceId
    }

    override func getRelativeURL() -> String {
        return "/restaurants/" + resourceId + "?lat=" + String((userLocation?.lat)!) + "&lon=" + String((userLocation?.lon)!)
    }
}

class GetSelectedCollectionsByLatAndLonRequest: HttpRequest{

    var userLocation: Location?

    override init(){
        super.init()
    }

    init(location: Location){
        self.userLocation = location
    }

    override func getRelativeURL() -> String {
        return "/selectedCollections?lat=" + String((userLocation?.lat)!) + "&lon=" + String((userLocation?.lon)!)
    }
}

class GetRestaurantCollectionMembersRequest: HttpRequest{

    var resourceId: String?

    init(id: String){
        self.resourceId = id
    }

    override func getRelativeURL() -> String {
        return "/selectedCollections/" + resourceId! + "/restaurantCollectionMembers"
    }
}

class GetRestaurantsRequest: HttpRequest{

    var limit : Int?
    var skip : Int?
    var sortBy : SortParameter?
    var sortOrder : SortOrder?
    var userLocation : Location?

    override func getRequestBody() -> [String : AnyObject] {
        var parameters = Dictionary<String, AnyObject>()
        if (userLocation != nil) {
            parameters["user_location"] = userLocation?.getProperties() as AnyObject
        }
        if limit != nil {
            parameters["limit"] = limit! as AnyObject
        }
        if skip != nil {
            parameters["skip"] = skip! as AnyObject
        }
        if sortBy != nil && sortOrder != nil{
            parameters["sort_by"] = sortBy!.description as AnyObject
            parameters["sort_order"] = sortOrder?.description as AnyObject
        }

        return parameters
    }

    override func getRelativeURL() -> String {
        return "/restaurants"
    }

}

class GetReviewByIdRequest: HttpRequest{

    var resourceId : String

    init(id : String) {
        resourceId = id
    }

    func getResourceId() -> String {
        return resourceId
    }

    override func getRelativeURL() -> String {
        return "/reviews/" + resourceId
    }
}

class GetAllReviewsOfOneRestaurantRequest: HttpRequest{

    var limit: Int = 50
    var skip: Int = 0
    var restaurantId: String?

    override func getRelativeURL() -> String {
        return "/restaurants\(restaurantId!)/reviews?limit=\(limit)&skip=\(skip)"
    }

}

class GetReviewByRestaurantIdOfOneUserRequest: HttpRequest{
    
    var restaurantId: String!
    
    override func getRelativeURL() -> String {
        return "/restaurants/" + restaurantId + "/reviewsOfOneUser/"
    }
}

class GetUserInfoRequest: HttpRequest{
    
    override func getRelativeURL() -> String {
        return "/userInfo"
    }
}

