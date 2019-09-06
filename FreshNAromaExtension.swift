//
//  FreshNAromaExtension.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 27/12/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    
    var isValidEmail: Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidEmail = emailTest.evaluate(with: self)
       return isValidEmail
    }
    
    
}
