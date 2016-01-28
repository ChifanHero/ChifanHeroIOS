//
//  DataAccessor.swift
//  Lightning
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class DataAccessor {
    
    var serviceConfiguration : ServiceConfiguration
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    func getPromotions(request: GetPromotionsRequest, responseHandler : (GetPromotionsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
                        var getPromotionsResponse : GetPromotionsResponse? = nil
                        if data != nil {
                            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            var jsonData : [String : AnyObject]
                            do {
                                jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                                getPromotionsResponse = GetPromotionsResponse(data: jsonData)
                            } catch {
                                print(error)
                            }
                        }
                        responseHandler(getPromotionsResponse)
        }
        
    }
    
    func getRestaurants(request: GetRestaurantsRequest, responseHandler : (GetRestaurantsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.post(url, headers: nil, parameters: request.getRequestBody()) { (data, response, error) -> Void in
                        var getRestaurantsResponse : GetRestaurantsResponse? = nil
                        if data != nil {
                            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            var jsonData : [String : AnyObject]
                            do {
                                jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                                getRestaurantsResponse = GetRestaurantsResponse(data: jsonData)
                            } catch {
                                print(error)
                            }
                        }
                        responseHandler(getRestaurantsResponse)
        }
    }
    
    func getLists(request: GetListsRequest, responseHandler : (GetListsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
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
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL() + "/" + request.getResourceId()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getRestaurantByIdResponse : GetRestaurantByIdResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getRestaurantByIdResponse = GetRestaurantByIdResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getRestaurantByIdResponse)
        }
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
    
    func getMessages(request: GetMessagesRequest, responseHandler : (GetMessagesResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getMessagesResponse : GetMessagesResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getMessagesResponse = GetMessagesResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getMessagesResponse)
        }
    }
    
    func getMessageById(request: GetMessageByIdRequest, responseHandler : (GetMessageByIdResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL() + "/" + request.getResourceId()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
            var getMessageByIdResponse : GetMessageByIdResponse? = nil
            if data != nil {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var jsonData : [String : AnyObject]
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData((strData?.dataUsingEncoding(NSUTF8StringEncoding))!, options: NSJSONReadingOptions.MutableLeaves) as! [String : AnyObject]
                    getMessageByIdResponse = GetMessageByIdResponse(data: jsonData)
                } catch {
                    print(error)
                }
            }
            responseHandler(getMessageByIdResponse)
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
    
    
    
}
