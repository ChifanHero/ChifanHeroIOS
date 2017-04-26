//
//  ControllerCommonConfiguration.swift
//  Lightning
//
//  Created by Zhang, Alex on 6/14/16.
//  Copyright © 2016 Lightning. All rights reserved.
//

import UIKit

protocol ControllerCommonConfigurationDelegate {
    func setTabBarVisible(_ visible:Bool, animated:Bool)
    func tabBarIsVisible() ->Bool
}
