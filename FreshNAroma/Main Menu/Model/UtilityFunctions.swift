//
//  UtilityFunctions.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 16/10/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
public func addQuantity(qty:Int) -> Int {
    var  qty = qty
    qty += 1
    return qty
}

public func minusQuantity(qty:Int) -> Int{
    var qty = qty
    qty -= 1
    return qty
}

struct UserInformationDefaultKey {
   
    let code = "code"
    let first_name = "first_name"
    let last_name = "last_name"
    let contact = "contact"
    let otp = "otp"
    let email_address = "email_address"
    let country = "country"
    let state = "state"
    let city = "city"
    let pin_code = "pin_code"
    let shipping_address = "shipping_address"
    let shipping_address2 = "shipping_address2"
    let bill_country = "bill_country"
    let bill_state = "bill_state"
    let bill_city  = "bill_city"
    let bill_pin_code = "bill_pin_code"
    let bill_address = "bill_address"
    let bill_address2 = "bill_address2"
    let bill_first_name = "bill_first_name"
    let bill_last_name = "bill_last_name"
    let bill_contact = "bill_contact"
    let bill_email_address = "bill_email_address"
}


struct UserDefaulKey {
    static var userdict = "dictuser"
    static var login = "login"
    static var code = "code"
    static var userData = "dataforuser"
    static var address = "address"
    static var first_name = "first_name"
    static var last_name = "last_name"
    static var contact = "contact"
    static var otp = "otp"
    static var email_address = "email_address"
    static var country = "country"
    static var state = "state"
    static var city = "city"
    static var pin_code = "pin_code"
    static var shipping_address = "shipping_address"
    static var shipping_address2 = "shipping_address2"
    static var bill_country = "bill_country"
    static var bill_state = "bill_state"
    static var bill_city  = "bill_city"
    static var bill_pin_code = "bill_pin_code"
    static var bill_address = "bill_address"
    static var bill_address2 = "bill_address2"
}


    var user_code = String()
    var user_first_name = String()
    var user_last_name = String()
    var user_contact = String()
    var user_email_address = String()
    var user_country = String()
    var user_state = String()
    var user_city = String()
    var user_pin_code = String()
    var user_shipping_address = String()
    var user_shipping_address2 = String()
    var user_bill_country = String()
    var user_bill_state = String()
    var user_bill_city  = String()
    var user_bill_pin_code = String()
    var user_bill_address = String()
    var user_bill_address2 = String()


    var CITY = "Coimbatore"
    var STATE = "Tamil nadu"
    var COUNTRY = "India"


func setUserDefautValeu(loginId : String,address: String){
    UserDefaults.standard.set( loginId, forKey: UserDefaulKey.code)
    UserDefaults.standard.set( address,forKey: UserDefaulKey.bill_address)
}



public func getSavedCustomerCode() -> String {
    
    let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
    let userCode = dict_UserInformation as? [String : AnyObject]
    
    if userCode != nil {
        let code = (userCode![UserDefaulKey.code]! as? String)!
        return code
    }
    return ""
}



enum CommonString: String {
    case alertMessageContinuetologin = "Kindly Login to Proceed Further."
    case alertMessageEmptyCart = "Do you sure want to remove all items in your basket?"
    
}

enum ViewControllerDisplayType: String {
    case closeView = "present"
    case pushView =  "navigation"
}
enum RazorPayAppKey: String {
    case testKey = "rzp_test_W57UXqJ4CJnQwc"
    case liveKey = "rzp_live_RSo6ifr3caLLnh"
    }

enum ImageIconName: String {
    case navigationBack = "navigationback"
    case navigationClose = "close"
}
public func getDateFromString(dateStr: String) -> String
{
    
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
   // let myString = formatter.string(from: Date()) // string purpose I add here
   
    let yourDate = formatter.date(from: dateStr)
    
    formatter.dateFormat = "dd-MM-yyyy"
   
    let myStringafd = formatter.string(from: yourDate!)
    return myStringafd
}
