//
//  Modals.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 11/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
import UIKit
class BasketEntity : NSObject {
    var id = ""
    var quantity = ""
    var name = ""
    var price = ""

    func initWithDict(dict : NSDictionary) {
        id = "\(checkKeyNotAvailInt(dict: dict, key: "id"))"
        quantity = checkKeyNotAvail(dict: dict, key: "quantity") as! String
        name = checkKeyNotAvail(dict: dict, key: "name") as! String
        price = checkKeyNotAvail(dict: dict, key: "price") as! String
      
    }
    
    func initWithEnt(ent : BasketEntity) {
        id = ent.id
        quantity = ent.quantity
        name = ent.name
        price = ent.price
}

}
