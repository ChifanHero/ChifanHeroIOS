//
//  EmailUtil.swift
//  ChifanHero
//
//  Created by Shi Yan on 9/9/17.
//  Copyright © 2017 Lightning. All rights reserved.
//

import Foundation

class EmailUtil {
    
    class func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print(emailTest.evaluate(with: email))
        return emailTest.evaluate(with: email)
    }
    
}
