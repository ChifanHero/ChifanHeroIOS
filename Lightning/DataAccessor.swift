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
    
    //Get--------------------------------------------------------------------------------------------------//
    func getPromotions(request: GetPromotionsRequest, responseHandler : (GetPromotionsResponse?) -> Void) {
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurants(request: GetRestaurantsRequest, responseHandler : (GetRestaurantsResponse?) -> Void) {
        self.callParseApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getLists(request: GetListsRequest, responseHandler : (GetListsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var getListsResponse : GetListsResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getListsResponse = GetListsResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getListsResponse)
        }
    }
    
    func getRestaurantById(request: GetRestaurantByIdRequest, responseHandler : (GetRestaurantByIdResponse?) -> Void) {
        self.callParseApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getDishById(request: GetDishByIdRequest, responseHandler : (GetDishByIdResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL() + "/" + request.getResourceId()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getDishByIdResponse : GetDishByIdResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getDishByIdResponse = GetDishByIdResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getDishByIdResponse)
        }
    }
    
    
    func getRestaurantMenu(request: GetRestaurantMenuRequest, responseHandler : (GetRestaurantMenuResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getRestaurantMenuResponse : GetRestaurantMenuResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getRestaurantMenuResponse = GetRestaurantMenuResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getRestaurantMenuResponse)
        }
    }
    
    func getListById(request : GetListByIdRequest, responseHandler : (GetListByIdResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL() + "/" + request.getResourceId()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getListByIdResponse : GetListByIdResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getListByIdResponse = GetListByIdResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getListByIdResponse)
        }
    }
    
    func getFavorites(request: GetFavoritesRequest, responseHandler: (GetFavoritesResponse?) -> Void){
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        
        httpClient.get(url, headers: httpHeaders) { (data, response, error) -> Void in
            var getFavoritesResponse: GetFavoritesResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getFavoritesResponse = GetFavoritesResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getFavoritesResponse)
        }

    }
    
    func getSelectedCollectionByLocation(request: GetSelectedCollectionsByLatAndLonRequest, responseHandler : (GetSelectedCollectionsByLatAndLonResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getSelectedCollectionsByLatAndLonResponse: GetSelectedCollectionsByLatAndLonResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getSelectedCollectionsByLatAndLonResponse = GetSelectedCollectionsByLatAndLonResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getSelectedCollectionsByLatAndLonResponse)
        }
    }
    
    func getRestaurantCollectionMembersById(request: GetRestaurantCollectionMembersRequest, responseHandler : (GetRestaurantCollectionMembersResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getRestaurantCollectionMembersResponse: GetRestaurantCollectionMembersResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getRestaurantCollectionMembersResponse = GetRestaurantCollectionMembersResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getRestaurantCollectionMembersResponse)
        }
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    
    
    
    
    
    //Post----------------------------------------------------------------------------------------------//
    func uploadPicture(request: UploadPictureRequest, responseHandler : (UploadPictureResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var uploadPictureResponse: UploadPictureResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    uploadPictureResponse = UploadPictureResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(uploadPictureResponse)
        }
        
    }
    
    func rate(request: RateRequest, responseHandler: (RateResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let defaults = NSUserDefaults.standardUserDefaults()
//        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        var httpHeaders = [String : String]()
        if defaults.stringForKey("sessionToken") != nil {
            httpHeaders["User-Session"] = defaults.stringForKey("sessionToken")!
//            httpHeaders.setValue(defaults.stringForKey("sessionToken")!, forKey: "User-Session")
        }
        
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var rateResponse: RateResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    rateResponse = RateResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(rateResponse)
        }
        
    }
    
    func addToFavorites(request: AddToFavoritesRequest, responseHandler: (AddToFavoritesResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        let defaults = NSUserDefaults.standardUserDefaults()
        //        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        var httpHeaders = [String : String]()
        if defaults.stringForKey("sessionToken") != nil {
            httpHeaders["User-Session"] = defaults.stringForKey("sessionToken")!
            //            httpHeaders.setValue(defaults.stringForKey("sessionToken")!, forKey: "User-Session")
        }
        
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var addToFavoritesResponse: AddToFavoritesResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    addToFavoritesResponse = AddToFavoritesResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(addToFavoritesResponse)
        }
        
    }
    
    func removeFavorite(request: RemoveFavoriteRequest, responseHandler: (RemoveFavoriteResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        //        let defaults = NSUserDefaults.standardUserDefaults()
        //        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        let defaults = NSUserDefaults.standardUserDefaults()
        //        let httpHeaders = ["User-Session": defaults.stringForKey("sessionToken")!]
        var httpHeaders = [String : String]()
        if defaults.stringForKey("sessionToken") != nil {
            httpHeaders["User-Session"] = defaults.stringForKey("sessionToken")!
            //            httpHeaders.setValue(defaults.stringForKey("sessionToken")!, forKey: "User-Session")
        }
        
        httpClient.delete(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var removeFavoriteResponse: RemoveFavoriteResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    removeFavoriteResponse = RemoveFavoriteResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(removeFavoriteResponse)
        }
        
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
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var httpHeaders = [String : String]()
        if defaults.stringForKey("sessionToken") != nil {
            httpHeaders["User-Session"] = defaults.stringForKey("sessionToken")!
        }
        
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var rateResponse: VoteRestaurantResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    rateResponse = VoteRestaurantResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(rateResponse)
        }
    }
    
    func nominateDishListCandidate(request: NominateDishListCandidateRequest, responseHandler: (NominateDishListCandidateResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
//        let defaults = NSUserDefaults.standardUserDefaults()
        let httpHeaders = [String : String]()
        
        httpClient.post(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var nominateResponse: NominateDishListCandidateResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    nominateResponse = NominateDishListCandidateResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(nominateResponse)
        }
    }
    
    func updateRestaurantInfo(request: UpdateRestaurantInfoRequest, responseHandler: (UpdateRestaurantInfoResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        //        let defaults = NSUserDefaults.standardUserDefaults()
        let httpHeaders = [String : String]()
        
        httpClient.put(url, headers: httpHeaders, parameters: request.getRequestBody()) { (data, response, error) -> Void in
            var updateResponse: UpdateRestaurantInfoResponse?
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding)!)!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    updateResponse = UpdateRestaurantInfoResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(updateResponse)
        }
    }
    
    func getCities(request: GetCitiesRequest, responseHandler: (GetCitiesResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getCitiesResponse : GetCitiesResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getCitiesResponse = GetCitiesResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getCitiesResponse)
        }
    }
    
    func getHotCities(request: GetHotCitiesRequest, responseHandler: (GetCitiesResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getCitiesResponse : GetCitiesResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getCitiesResponse = GetCitiesResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getCitiesResponse)
        }
    }
    
    
    func nominateRestaurantForCollection(request: NominateRestaurantRequest, responseHandler: (NominateRestaurantResponse?) -> Void){
        
        self.callParseApi(method: "PUT", request: request, responseHandler: responseHandler)
        
    }
    
    private func callParseApi<Response: HttpResponseProtocol>(method method: String, request: HttpRequestProtocol, responseHandler: (Response?) -> Void){
        
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        
        switch method {
            case "GET":
                Alamofire.request(.GET, url).validate().responseJSON { response in
                    
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
                Alamofire.request(.POST, url, parameters: request.getRequestBody(), encoding: .JSON).validate().responseJSON { response in
                    
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
                Alamofire.request(.PUT, url, parameters: request.getRequestBody(), encoding: .JSON).validate().responseJSON { response in
                    
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
                Alamofire.request(.DELETE, url, parameters: request.getRequestBody(), encoding: .JSON).validate().responseJSON { response in
                    
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
}
