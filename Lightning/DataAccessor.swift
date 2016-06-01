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
    
    private func callParseApi<Response: HttpResponseProtocol>(method method: String, request: HttpRequestProtocol, responseHandler: (Response?) -> Void){
        
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
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurants(request: GetRestaurantsRequest, responseHandler : (GetRestaurantsResponse?) -> Void) {
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurantById(request: GetRestaurantByIdRequest, responseHandler : (GetRestaurantByIdResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    
    func getRestaurantMenu(request: GetRestaurantMenuRequest, responseHandler : (GetRestaurantMenuResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getFavorites(request: GetFavoritesRequest, responseHandler: (GetFavoritesResponse?) -> Void){
        let defaults = NSUserDefaults.standardUserDefaults()
        request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getSelectedCollectionByLocation(request: GetSelectedCollectionsByLatAndLonRequest, responseHandler : (GetSelectedCollectionsByLatAndLonResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurantCollectionMembersById(request: GetRestaurantCollectionMembersRequest, responseHandler : (GetRestaurantCollectionMembersResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    
    
    
    
    
    //Post----------------------------------------------------------------------------------------------//
    func uploadPicture(request: UploadPictureRequest, responseHandler : (UploadPictureResponse?) -> Void) {
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func rate(request: RateRequest, responseHandler: (RateResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func addToFavorites(request: AddToFavoritesRequest, responseHandler: (AddToFavoritesResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
        
    }
    
    func removeFavorite(request: RemoveFavoriteRequest, responseHandler: (RemoveFavoriteResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callParseApi(method: "DELETE", request: request, responseHandler: responseHandler)
    }
    
    func searchRestaurants(request: RestaurantSearchRequest, responseHandler : (RestaurantSearchResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        var httpHeaders = [String : String]()
        httpHeaders["Accept-Language"] = "zh-CN"
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var restaurantSearchResponse: RestaurantSearchResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    restaurantSearchResponse = RestaurantSearchResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(restaurantSearchResponse)
        }
        
    }
    
    func searchDishes(request: DishSearchRequest, responseHandler : (DishSearchResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        var httpHeaders = [String : String]()
        httpHeaders["Accept-Language"] = "zh-CN"
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var dishSearchResponse: DishSearchResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    dishSearchResponse = DishSearchResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(dishSearchResponse)
        }
    }
    
    func searchLists(request: DishListSearchRequest, responseHandler : (DishListSearchResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var dishListSearchResponse: DishListSearchResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    dishListSearchResponse = DishListSearchResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(dishListSearchResponse)
        }
    }
    
    func voteRestaurant(request: VoteRestaurantRequest, responseHandler: (VoteRestaurantResponse?) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.stringForKey("sessionToken")!)
        }
        
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func updateRestaurantInfo(request: UpdateRestaurantInfoRequest, responseHandler: (UpdateRestaurantInfoResponse?) -> Void) {
        self.callParseApi(method: "PUT", request: request, responseHandler: responseHandler)
    }
    
    func getCities(request: GetCitiesRequest, responseHandler: (GetCitiesResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getHotCities(request: GetHotCitiesRequest, responseHandler: (GetCitiesResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    
    func nominateRestaurantForCollection(request: NominateRestaurantRequest, responseHandler: (NominateRestaurantResponse?) -> Void){
        self.callParseApi(method: "PUT", request: request, responseHandler: responseHandler)
    }
}
