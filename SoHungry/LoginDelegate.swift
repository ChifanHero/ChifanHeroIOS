//
//  LoginDelegate.swift
//  SoHungry
//
//  Created by Shi Yan on 10/3/15.
//  Copyright © 2015 Shi Yan. All rights reserved.
//

import Foundation

protocol LoginDelegate {
    
    func logIn(account account : String?, password : String?)
    
    func logInWithSina()
    
    func signUp()
    
}