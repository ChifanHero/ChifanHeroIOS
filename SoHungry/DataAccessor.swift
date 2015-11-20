//
//  DataAccessor.swift
//  SoHungry
//
//  Created by Shi Yan on 8/15/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class DataAccessor {
    
    var serviceConfiguration : ServiceConfiguration
    
    init (serviceConfiguration : ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    func getPromotions(request : GetPromotionsRequest, responseHandler : (GetPromotionsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
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
    
    func getRestaurants(request : GetRestaurantsRequest, responseHandler : (GetRestaurantsResponse?) -> Void) {
        let httpClient = HttpClient()
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        print(url)
        httpClient.get(url, headers: nil) { (data, response, error) -> Void in
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
    
    func getLists(request : GetListsRequest, responseHandler : (GetListsResponse?) -> Void) {
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
    
    func getRestaurantById(request : GetRestaurantByIdRequest, responseHandler : (GetRestaurantByIdResponse?) -> Void) {
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
    
    func getDishById(request : GetDishByIdRequest, responseHandler : (GetDishByIdResponse?) -> Void) {
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
    
    func getMessages(request : GetMessagesRequest, responseHandler : (GetMessagesResponse?) -> Void) {
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
    
    func getMessageById(request : GetMessageByIdRequest, responseHandler : (GetMessageByIdResponse?) -> Void) {
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
    
    
    func getRestaurantMenu(request : GetRestaurantMenuRequest, responseHandler : (GetRestaurantMenuResponse?) -> Void) {
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
        print(defaults.stringForKey("sessionToken"))
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
    
    
    
}
