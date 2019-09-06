//
//  Constant.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 04/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import CoreTelephony


enum ColorCode: String {
    case yellow = "#F7C100"
    case orange = "#c88226"
    case green = "#7AB360"
    case gray = "#565656"
    case gray95 = "#f2f2f2"
    case actionGoGreen = "#61B851"
    case actionCautionRed = "#CD5C5C"
    case black = "#000000"
    case VeryLightGrayColorCode = "#FAFAFA"
    case LightGrayColorCode = "#E0E0E0"
    case tableViewBGColor = "#EEEEEE"
    case GreenColorCOde = "#47A740"
}

enum SearchProduct : String {
    case product = "product"
    case special = "special"
}

class Constants  {
    static let ALERT_SERVER_ERROR               =   "Unable to reach server. Please try later"
    
    static let ALERT_NETWORK_ERROR              =   "No internet connection. Please check your connection settings."
   
       static let apiReturnerror = "error"
       static let apiNoInternet = "noNet"
   
    
static func IS_IPAD() -> Bool {
    
    if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
        
        return true
        
    }
    else{
        
        return false
        
    }
    
}
   
 
}
struct BasketData {
    static  var userSelectedItems = [[String: String]]()
    static var badge = Int()
}
let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
