//
//  DataAccessor.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataAccessor {
    
    var serviceConfiguration : ServiceConfiguration
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    private func callApi<Response: HttpResponseProtocol>(method method: String, request: HttpRequestProtocol, responseHandler: (Response?) -> Void){
        
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        switch method {
        case "GET":
            Alamofire.request(.GET, url, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json.dictionaryObject!)
                    }
                case .Failure(let error):
                    print(error)
                }
                
                responseHandler(responseObject)
            }
        case "POST":
            Alamofire.request(.POST, url, parameters: request.getRequestBody(), encoding: .JSON, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json.dictionaryObject!)
                    }
                case .Failure(let error):
                    print(error)
                }
                
                responseHandler(responseObject)
            }
        case "PUT":
            Alamofire.request(.PUT, url, parameters: request.getRequestBody(), encoding: .JSON, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json.dictionaryObject!)
                    }
                case .Failure(let error):
                    print(error)
                }
                
                responseHandler(responseObject)
            }
            
        case "DELETE":
            Alamofire.request(.DELETE, url, parameters: request.getRequestBody(), encoding: .JSON, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json.dictionaryObject!)
                    }
                case .Failure(let error):
                    print(error)
                }
                
                responseHandler(responseObject)
            }
        default: break
        }
    }
    
    //Get--------------------------------------------------------------------------------------------------//
    func getPromotions(request: GetPromotionsRequest, responseHandler : (GetPromotionsResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurants(request: GetRestaurantsRequest, responseHandler : (GetRestaurantsResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurantById(request: GetRestaurantByIdRequest, responseHandler : (GetRestaurantByIdResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    
    func getRestaurantMenu(request: GetRestaurantMenuRequest, responseHandler : (GetRestaurantMenuResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getFavorites(request: GetFavoritesRequest, responseHandler: (GetFavoritesResponse?) -> Void){
        let defaults = NSUserDefaults.standardUserDefaults()
        request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getSelectedCollectionByLocation(request: GetSelectedCollectionsByLatAndLonRequest, responseHandler : (GetSelectedCollectionsByLatAndLonResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurantCollectionMembersById(request: GetRestaurantCollectionMembersRequest, responseHandler : (GetRestaurantCollectionMembersResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    
    
    
    
    
    //Post----------------------------------------------------------------------------------------------//
    func uploadPicture(request: UploadPictureRequest, responseHandler : (UploadPictureResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func rate(request: RateRequest, responseHandler: (RateResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func addToFavorites(request: AddToFavoritesRequest, responseHandler: (AddToFavoritesResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
        
    }
    
    func removeFavorite(request: RemoveFavoriteRequest, responseHandler: (RemoveFavoriteResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callApi(method: "DELETE", request: request, responseHandler: responseHandler)
    }
    
    func searchRestaurants(request: RestaurantSearchRequest, responseHandler : (RestaurantSearchResponse?) -> Void) {
        
        request.addHeader(key: "Accept-Language", value: "zh-CN")
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func searchDishes(request: DishSearchRequest, responseHandler : (DishSearchResponse?) -> Void) {
        
        request.addHeader(key: "Accept-Language", value: "zh-CN")
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func searchLists(request: DishListSearchRequest, responseHandler : (DishListSearchResponse?) -> Void) {
        request.addHeader(key: "Accept-Language", value: "zh-CN")
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func voteRestaurant(request: VoteRestaurantRequest, responseHandler: (VoteRestaurantResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func updateRestaurantInfo(request: UpdateRestaurantInfoRequest, responseHandler: (UpdateRestaurantInfoResponse?) -> Void) {
        self.callApi(method: "PUT", request: request, responseHandler: responseHandler)
    }
    
    func getCities(request: GetCitiesRequest, responseHandler: (GetCitiesResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getHotCities(request: GetHotCitiesRequest, responseHandler: (GetCitiesResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    
    func nominateRestaurantForCollection(request: NominateRestaurantRequest, responseHandler: (NominateRestaurantResponse?) -> Void){
        self.callApi(method: "PUT", request: request, responseHandler: responseHandler)
    }
}
