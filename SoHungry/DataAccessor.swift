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
        httpClient.get(url, headers: nil, parameters: request.getParameters()) { (data, response, error) -> Void in
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
        httpClient.get(url, headers: nil, parameters: request.getParameters()) { (data, response, error) -> Void in
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
        httpClient.get(url, headers: nil, parameters: request.getParameters()) { (data, response, error) -> Void in
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
        httpClient.get(url, headers: nil, parameters: nil) { (data, response, error) -> Void in
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
        httpClient.get(url, headers: nil, parameters: nil) { (data, response, error) -> Void in
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
    
    
    
    
}
