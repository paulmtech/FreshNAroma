//
//  APIFreshNAroma.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 23/11/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Foundation
import Alamofire




//Mark:Category
public struct CategoryRootClass:Decodable {
    
    public var Response : [CategoryResponse]!
    public var Results : [CategoryResult]!
    
}
public struct CategoryResult:Decodable {
    
    public var category : String!
    public var categoryimage : String!
    public var created_date : String!
    public var deleted_status : String!
    public var id : String!
    public var image : String!
    
}

public struct CategoryResponse:Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
//Mark:SubCategory
public struct subcategoryRootClass:Decodable {
    
    public var Response : [subcategoryResponse]!
    public var Results : [subcategoryResult]!
    
}
public struct subcategoryResult:Decodable {
    
    public var category : String!
    public var created_date : String!
    public var deleted_status : String!
    public var id : String!
    public var sub_category : String!
    
}
public struct subcategoryResponse:Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
//Mark:SubCategoryProducts
public struct SubcategoryProductsRootClass:Decodable {
    
    public var Response : [SubcategoryProductsResponse]!
    public var Results : [OffersResult]!
    
}
public struct SubcategoryProductsResult :Decodable{
    
    public var id: String?
    public var hsn_code:String?
    public var pdt_code:String?
    public var category:String?
    public var sub_category: String?
    public var pdt_name: String?
    public var  pdt_name_tamil:String?
    public var pdt_description:String?
    public var  pdt_unit:String?
    public var pdt_type:String?
    public var pdt_barcode:String?
    public var pdt_price:String?
    public var selling_price:String?
    public var mrp:String?
    public var disc:String?
    public var cgst:String?
    public var sgst:String?
    public var available:String?
    public var batch:String?
    public var profile_picture:String?
    public var gst_slab:String?
    public var cmp_commission:String?
    public var selling_percent:String?
    public var warehouse_percent: String?
    public var unit_percent: String?
    public var unit_sales_price:String?
    public var wh_sales_price: String?
    public var status: String?
    public var visible:String?
    public var barcode_status:String?
    public var approve_status: String?
    public var updated_date:String?
    public var updated_by: String?
    public var updated_ip: String?
    public var productimage:String?
    
}
public struct SubcategoryProductsResponse:Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
