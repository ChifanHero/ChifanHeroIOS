//
//  GetFavoritesRequest.swift
//  Lightning
//
//  Created by Zhang, Alex on 11/13/15.
//  Copyright © 2015 Lightning. All rights reserved.
//

import Foundation

class GetFavoritesRequest: HttpRequestProtocol{
    
    var favoriteType: String
    
    init(type: FavoriteTypeEnum){
        if type == FavoriteTypeEnum.Restaurant{
            self.favoriteType = "restaurant"
        } else if type == .Dish {
            self.favoriteType = "dish"
        } else {
            self.favoriteType = "list"
        }
    }
    
    func getRelativeURL() -> String {
        return "/favorites?type=" + favoriteType
    }
    
    func getRequestBody() -> [String : AnyObject] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
}