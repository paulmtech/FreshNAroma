//
//  DeCodableModel.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 20/12/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
//public struct UserInfoRootClass :Decodable {
//
//    public var Response : [UserInfoResponse]!
//    public var CustomerInfo : [UserInfoResult]!
//
//}
public struct UserInfoRootClass :Decodable {
    
    public var CustomerInfo : [UserInfoCustomerInfo]!
    public var Response : [UserInfoResponse]!
    
}
public struct UserInfoCustomerInfo :Decodable{
    
    public var  id: String!
    public var  code: String!
    public var  first_name: String!
    public var  last_name: String!
    public var  contact: String!
    public var  otp: String!
    public var  email_address: String!
    public var  country: String!
    public var  state: String!
    public var  city: String!
    public var   pin_code: String!
    public var   shipping_address: String!
    public var shipping_address2: String!
    public var bill_first_name: String!
    public var  bill_last_name: String!
    public var  bill_contact: String!
    public var  bill_email_address: String!
    public var  bill_country: String!
    public var  bill_state: String!
    public var  bill_city: String!
    public var  bill_pin_code: String!
    public var  bill_address: String!
    public var bill_address2: String!
    public var  status: String!
    public var wallet_point: String!
    public var ref_level1: String!
    public var ref_level2: String!
    public var created_date: String!
    public var created_ip: String!
    public var  updated_date: String!
    public var  updated_ip: String!
    public var deleted_status: String!
    
}
public struct UserInfoResponse :Decodable{
    
    public var response_code : String!
    public var response_msg : String!
    
}

//Mark:- Districk
public struct DistrickRootClass : Decodable {
    
    public var Response : [DistrickResponse]!
    public var Results : [DistrickResult]!
    
}
public struct DistrickResult : Decodable{
    
    public var district_name : String!
    public var id : String!
    public var status : String!
    
}
public struct DistrickResponse: Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
