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
    
    var serviceConfiguration: ServiceConfiguration
    
    init (serviceConfiguration: ServiceConfiguration) {
        self.serviceConfiguration = serviceConfiguration
    }
    
    private func callApi<Response: HttpResponseProtocol>(method: String, request: HttpRequestProtocol, responseHandler: @escaping (Response?) -> Void){
        
        let url = self.serviceConfiguration.hostEndpoint() + request.getRelativeURL()
        log.debug("\(method) \(url)")
        
        switch method {
        case "GET":
            Alamofire.request(url, method: .get, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                switch response.result {
                case .success:
                    if let value = response.value {
                        let json = JSON(value)
                        responseObject = Response(data: json)
                    }
                case .failure(let error):
                    log.debug(error)
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(parseJSON: utf8Text)
                        responseObject = Response(data: json)
                    }
                }
                
                responseHandler(responseObject)
            }
        case "POST":
            Alamofire.request(url, method: .post, parameters: request.getRequestBody(), encoding: JSONEncoding.default, headers: request.getHeaders()).validate().responseJSON { response in
                var responseObject: Response?
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json)
                    }
                case .failure(let error):
                    log.debug(error)
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(parseJSON: utf8Text)
                        responseObject = Response(data: json)
                    }
                }
                
                responseHandler(responseObject)
            }
        case "PUT":
            Alamofire.request(url, method: .put, parameters: request.getRequestBody(), encoding: JSONEncoding.default, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json)
                    }
                case .failure(let error):
                    log.debug(error)
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(parseJSON: utf8Text)
                        responseObject = Response(data: json)
                    }
                }
                
                responseHandler(responseObject)
            }
            
        case "DELETE":
            Alamofire.request(url, method: .delete, parameters: request.getRequestBody(), encoding: JSONEncoding.default, headers: request.getHeaders()).validate().responseJSON { response in
                
                var responseObject: Response?
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        responseObject = Response(data: json)
                    }
                case .failure(let error):
                    log.debug(error)
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(parseJSON: utf8Text)
                        responseObject = Response(data: json)
                    }
                }
                
                responseHandler(responseObject)
            }
        default: break
        }
    }
    
    //Get--------------------------------------------------------------------------------------------------//
    func getRestaurants(_ request: GetRestaurantsRequest, responseHandler : @escaping (GetRestaurantsResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurantById(_ request: GetRestaurantByIdRequest, responseHandler : @escaping (GetRestaurantByIdResponse?) -> Void) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getFavorites(_ request: GetFavoritesRequest, responseHandler: @escaping (GetFavoritesResponse?) -> Void){
        let defaults = UserDefaults.standard
        request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getIsFavorite(_ request: GetIsFavoriteRequest, responseHandler: @escaping (GetIsFavoriteResponse?) -> Void){
        let defaults = UserDefaults.standard
        request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getSelectedCollectionByLocation(_ request: GetSelectedCollectionsByLatAndLonRequest, responseHandler : @escaping (GetSelectedCollectionsByLatAndLonResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getRestaurantCollectionMembersById(_ request: GetRestaurantCollectionMembersRequest, responseHandler : @escaping (GetRestaurantCollectionMembersResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    //TODO: Don't need this api for now
    /*
    func getImagesByRestaurantId(_ request: GetImagesRequest, responseHandler : @escaping (GetImagesResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }*/
    
    func getHomepage(_ request: GetHomepageRequest, responseHandler : @escaping (GetHomepageResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getReviews(_ request: GetAllReviewsOfOneRestaurantRequest, responseHandler: @escaping (GetAllReviewsOfOneRestaurantResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getReviewById(_ request: GetReviewByIdRequest, responseHandler: @escaping (GetReviewByIdResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getCities(_ request: GetCitiesRequest, responseHandler: @escaping (GetCitiesResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getHotCities(_ request: GetHotCitiesRequest, responseHandler: @escaping (GetCitiesResponse?) -> Void) {
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func searchRestaurants(_ request: RestaurantSearchV2Request, responseHandler : @escaping (RestaurantSearchResponse?) -> Void) {
        
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getMyInfo(_ request: GetMyInfoRequest, responseHandler: @escaping (GetMyInfoResponse?) -> Void) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func isEmailVerified(_ request: GetEmailVerifiedRequest, responseHandler: @escaping (GetEmailVerifiedResponse?) -> Void) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    func getAppVersionInfo(_ request: GetAppVersionInfoRequest, responseHandler : @escaping (GetAppVersionInfoResponse?) -> Void) {
        
        self.callApi(method: "GET", request: request, responseHandler: responseHandler)
    }
    
    //Post----------------------------------------------------------------------------------------------//
    func uploadPicture(_ request: UploadPictureRequest, responseHandler: @escaping (UploadPictureResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func addToFavorites(_ request: AddToFavoritesRequest, responseHandler: @escaping (AddToFavoritesResponse?) -> Void) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
        
    }
    
    func upsertReview(_ request: UpsertReviewRequest, responseHandler: @escaping (UpsertReviewResponse?) -> Void){
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func addRecommendedDish(_ request: AddRecommendDishRequest, responseHandler: @escaping (AddRecommendDishResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func updateRestaurantInfo(_ request: UpdateRestaurantInfoRequest, responseHandler: @escaping (UpdateRestaurantInfoResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func trackRestaurant(_ request: TrackRestaurantRequest, responseHandler: @escaping (TrackRestaurantResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    func resetPassword(_ request: ResetPasswordRequest, responseHandler: @escaping (ResetPasswordResponse?) -> Void) {
        self.callApi(method: "POST", request: request, responseHandler: responseHandler)
    }
    
    //Put----------------------------------------------------------------------------------------------//
    
    func nominateRestaurantForCollection(_ request: NominateRestaurantRequest, responseHandler: @escaping (NominateRestaurantResponse?) -> Void){
        self.callApi(method: "PUT", request: request, responseHandler: responseHandler)
    }
    
    //Delete-------------------------------------------------------------------------------------------//
    func removeFavorite(_ request: RemoveFavoriteRequest, responseHandler: @escaping (RemoveFavoriteResponse?) -> Void) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "sessionToken") != nil {
            request.addHeader(key: "User-Session", value: defaults.string(forKey: "sessionToken")!)
        }
        
        self.callApi(method: "DELETE", request: request, responseHandler: responseHandler)
    }
    
    func deletePictures(_ request: DeletePicturesRequest, responseHandler: @escaping (DeletePicturesResponse?) -> Void) {
        self.callApi(method: "DELETE", request: request, responseHandler: responseHandler)
    }
    
}
