//
//  TrackingUtil.swift
//  Lightning
//
//  Created by Shi Yan on 6/14/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import Foundation
import Flurry_iOS_SDK

class TrackingUtil {
    
    
    class func trackRecommendationView() {
        Flurry.logEvent("RecommendationView")
    }
    
    class func trackRestaurantsView() {
        Flurry.logEvent("RestaurantsView")
    }
    
    class func trackRestaurantView() {
        Flurry.logEvent("RestaurantView")
    }
    
    class func trackCollectionsView() {
        Flurry.logEvent("CollectionsView")
    }
    
    class func trackCollectionsMemberView() {
        Flurry.logEvent("CollectionsMemberView")
    }
    
    class func trackRestaurantNominationView() {
        Flurry.logEvent("RestaurantNominationView")
    }
    
    class func trackSearchView() {
        Flurry.logEvent("SearchView")
    }
    
    class func trackNotificationsView() {
        Flurry.logEvent("NotificationsView")
    }
    
    class func trackNotificationContentView() {
        Flurry.logEvent("NotificationCotentView")
    }
    
    class func trackRestaurantAllDishView() {
        Flurry.logEvent("RestaurantAllDishView")
    }
    
    class func trackLoginView() {
        Flurry.logEvent("LoginView")
    }
    
    class func trackSignupView() {
        Flurry.logEvent("SignupView")
    }
    
    class func trackUserProfileView() {
        Flurry.logEvent("UserProfileView")
    }
    
    class func trackUserFaroviteAndLikeView() {
        Flurry.logEvent("UserFaroviteAndLikeView")
    }
    
    class func trackUserNicknameChangeView() {
        Flurry.logEvent("UserNicknameChangeView")
    }
    
    class func trackSelectLocationView() {
        Flurry.logEvent("SelectLocationView")
    }
    
    
}
