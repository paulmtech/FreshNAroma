//
//  ProductViewModal.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 26/06/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
import UIKit
class Item {
    var itemId: String
    var itemName : String
    var itemMRP : String
    var itemPrice : String
    var itemSaved : String
    var itemImage: String
    init(id : String,name : String,mrp : String,price:String,saved: String,image: String) {
        self.itemId = id
        self.itemName = name
        self.itemMRP = mrp
        self.itemPrice = price
        self.itemSaved = saved
        self.itemImage = image
    }
}

class ItemViewModel {
    var itemId: String
    var itemName : String
    var itemMRP : String
    var itemPrice : String
    var itemSaved : String
    var itemImage: String
    
    init(item:Item) {
        self.itemId = item.itemId
        self.itemName = item.itemName
        self.itemMRP = item.itemMRP
        self.itemImage = item.itemImage
        self.itemPrice = item.itemPrice
        self.itemSaved = item.itemSaved
    }
}
