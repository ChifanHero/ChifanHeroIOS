//
//  GetFavoritesRequest.swift
//  SoHungry
//
//  Created by Zhang, Alex on 11/13/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

class GetFavoritesRequest: GetRequestProtocol{
    
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
    
    func getParameters() -> [String:String] {
        let parameters = Dictionary<String, String>()
        return parameters
    }
    
    func getRelativeURL() -> String {
        return "/favorites?type=" + favoriteType
    }
}