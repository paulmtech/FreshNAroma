//
//  Commonfile.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 06/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto
import SwiftyJSON

public let appPlaceholerImage = "placehold_vegetables"
public let RupeeSymbol = "₹"

public func FONT_BOLD(size: Float) -> UIFont {
    
    if Constants.IS_IPAD() {
        
        return UIFont(name: "MavenPro-Regular", size: CGFloat(size + 5))!
    }
        
    else {
        
        return UIFont(name: "MavenPro-Regular", size: CGFloat(size))!
        
    }
    
}


public   func setCornerRadius(view: UIView) -> UIView {
    view.layer.cornerRadius = 5
    view.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.GreenColorCOde.rawValue, alphavalue: 1).cgColor
    view.layer.borderWidth = 1
    view.clipsToBounds = true
    return view
}
public   func setViewBorder(view: UIView,bradious: Float,bwidth: Float,bcolor:UIColor) -> UIView {
    view.layer.cornerRadius = CGFloat(bradious)
    view.layer.borderColor = bcolor.cgColor
    view.layer.borderWidth = CGFloat(bwidth)
    view.clipsToBounds = true
    return view
}
// MARK:- UTILITY FUNC
public func checkKeyNotAvail( dict: NSDictionary, key:String) -> AnyObject
{
    
    if let val = dict[key]
    {
        if val is String
        {
            return val as AnyObject
        }
        else if val is Int {
            
            return "\(val)" as AnyObject
        }
        
        return "\(val)" as AnyObject
    }
    else {
        
        return "" as AnyObject
    }
}
public func safeStringRetrieve( dict: NSDictionary, key:String) -> String?
{
    
    if let val = dict[key]
    {
        if val is String
        {
            return val as? String
        }
        else if val is Int {
            
            return "\(val)" as String
        }
        
        return "\(val)" as String
    }
    else {
        
        return nil
    }
}
public func checkKeyNotAvailInt( dict: NSDictionary, key:String) -> AnyObject
{
    if let val = dict[key]
    {
        if val is Int
        {
            return val as AnyObject
        }
        return 0 as AnyObject
    }
    else {
        
        return 0 as AnyObject
    }
}
public func checkKeyNotAvailForArray( dict: NSDictionary, key:String) -> AnyObject
{
    if let val = dict[key]
    {
        if val is NSArray
        {
            return val as AnyObject
        }
        return NSArray()
    }
    else
    {
        return NSArray()
    }
}
//This should return nil if there are no such keys
public func safeValueRetrive( dict: NSDictionary, key:String) -> AnyObject? {
    if let val = dict[key]  {
        if val is NSDictionary  {
            return val as AnyObject
        }
        return nil
    }
    else {
        return nil
    }
}
public func checkKeyNotAvailForDictionary( dict: NSDictionary, key:String) -> AnyObject {
    if let val = dict[key]  {
        if val is NSDictionary  {
            return val as AnyObject
        }
        return NSDictionary()
    }
    else {
        return NSDictionary()
    }
    
   
}
public func intFromString(stringValue :String) -> Int {
    let string = stringValue.trimmingCharacters(in: .whitespaces)
    let intValue:Int? = Int(string)
    return intValue!
}
public func doubleFromString(stringValue : String) -> Double {
    let string = stringValue.trimmingCharacters(in: .whitespaces)
    let doubleValue : Double? = Double(string)
    return doubleValue!;
}
public func floatFromString(stringValue : String) -> Float{
    let string = stringValue.trimmingCharacters(in: .whitespaces)
    let doubleValue : Float? = Float(string)
    return doubleValue!;
}
extension String {
    var md5: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.MD5)
    }
    
    var sha1: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA1)
    }
    
    var sha224: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA224)
    }
    
    var sha256: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA256)
    }
    
    var sha384: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA384)
    }
    
//    var sha512: String {
//        return HMAC.hash(inp: self, algo: HMACAlgo.SHA512)
//    }
}

public struct HMAC {
    
    static func hash(inp: String, algo: HMACAlgo) -> String {
        if let stringData = inp.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            return hexStringFromData(input: digest(input: stringData as NSData, algo: algo))
        }
        return ""
    }
    
    private static func digest(input : NSData, algo: HMACAlgo) -> NSData {
        let digestLength = algo.digestLength()
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch algo {
        case .MD5:
            CC_MD5(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA1:
            CC_SHA1(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA224:
            CC_SHA224(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA256:
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA384:
            CC_SHA384(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA512:
            CC_SHA512(input.bytes, UInt32(input.length), &hash)
            break
        }
        return NSData(bytes: hash, length: digestLength)
    }
    
    private static func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

enum HMACAlgo {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
//MARK: - ADD


public let appThemColor = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1.0)

public func getPQty(qty: String) -> String{
    let qty = intFromString(stringValue: qty)
    return String(qty+1)
}
public func getMQty(qty: String) -> String{
    let qty = intFromString(stringValue: qty)
    return String(qty-1)
}
enum ProductInfo: String {
    case id = "id"
    case hsn_code = "hsn_code"
    case pdt_code = "pdt_code"
    case category = "category"
    case sub_category = "sub_category"
    case pdt_name = "pdt_name"
    case pdt_name_tamil = "pdt_name_tamil"
    case pdt_description = "pdt_description"
    case pdt_unit = " pdt_unit"
    case pdt_type = "pdt_type"
    case pdt_barcode = "pdt_barcode"
    case pdt_price = "pdt_price"
    case selling_price = "selling_price"
    case mrp = "mrp"
    case disc = "disc"
    case cgst = "cgst"
    case sgst = "sgst"
    case available = "available"
    case batch = "batch"
    case profile_picture = "profile_picture"
    case gst_slab = "gst_slab"
    case cmp_commission = "cmp_commission"
    case selling_percent = "selling_percent"
    case warehouse_percent = "warehouse_percent"
    case unit_percent = "unit_percent"
    case unit_sales_price = "unit_sales_price"
    case wh_sales_price = "wh_sales_price"
    case status = "status"
    case visible = "visible"
    case barcode_status = "barcode_status"
    case approve_status = "approve_status"
    case updated_date = "updated_date"
    case updated_by = "updated_by"
    case updated_ip = "updated_ip"
    case productimage = "productimage"
    case qty = "qty"
}
public func itemFromDecodeObject(product : [OffersResult]) -> [String:String]{
    let productInfo = ["id": product[0].id,
                       "hsn_code": product[0].hsn_code,
                       "pdt_code": product[0].pdt_code,
                       "category": product[0].category,
                       "sub_category": product[0].sub_category,
                       "pdt_name": product[0].pdt_name,
                       "pdt_name_tamil": product[0].pdt_name_tamil,
                       "pdt_description": product[0].pdt_description,
                       " pdt_unit": product[0].pdt_unit,
                       "pdt_type": product[0].pdt_type,
                       "pdt_barcode": product[0].pdt_barcode,
                       "pdt_price": product[0].pdt_price,
                       "selling_price": product[0].selling_price,
                       "mrp": product[0].mrp,
                       "disc": product[0].disc,
                       "cgst": product[0].cgst,
                       "sgst": product[0].sgst,
                       "available": product[0].available,
                       "batch": product[0].batch,
                       "profile_picture": product[0].profile_picture,
                       "gst_slab": product[0].gst_slab,
                       "cmp_commission": product[0].cmp_commission,
                       "selling_percent": product[0].selling_percent,
                       "warehouse_percent": product[0].warehouse_percent,
                       "unit_percent": product[0].unit_percent,
                       "unit_sales_price": product[0].unit_sales_price,
                       "wh_sales_price": product[0].wh_sales_price,
                       "status": product[0].status,
                       "visible": product[0].visible,
                       "barcode_status":product[0].barcode_status,
                       "approve_status": product[0].approve_status,
                       "updated_date": product[0].updated_date,
                       "updated_by": product[0].updated_by,
                       "updated_ip": product[0].updated_ip,
                       "productimage": product[0].productimage,
                       "qty" : "0"
        
    ]
    return productInfo as! [String : String]
}

public func itemFromDecodeObjectOffer(product : [OffersResult]) -> [String:String]{
    let productInfo = ["id": product[0].id,
                       "hsn_code": product[0].hsn_code,
                       "pdt_code": product[0].pdt_code,
                       "category": product[0].category,
                       "sub_category": product[0].sub_category,
                       "pdt_name": product[0].pdt_name,
                       "pdt_name_tamil": product[0].pdt_name_tamil,
                       "pdt_description": product[0].pdt_description,
                       " pdt_unit": product[0].pdt_unit,
                       "pdt_type": product[0].pdt_type,
                       "pdt_barcode": product[0].pdt_barcode,
                       "pdt_price": product[0].pdt_price,
                       "selling_price": product[0].selling_price,
                       "mrp": product[0].mrp,
                       "disc": product[0].disc,
                       "cgst": product[0].cgst,
                       "sgst": product[0].sgst,
                       "available": product[0].available,
                       "batch": product[0].batch,
                       "profile_picture": product[0].profile_picture,
                       "gst_slab": product[0].gst_slab,
                       "cmp_commission": product[0].cmp_commission,
                       "selling_percent": product[0].selling_percent,
                       "warehouse_percent": product[0].warehouse_percent,
                       "unit_percent": product[0].unit_percent,
                       "unit_sales_price": product[0].unit_sales_price,
                       "wh_sales_price": product[0].wh_sales_price,
                       "status": product[0].status,
                       "visible": product[0].visible,
                       "barcode_status":product[0].barcode_status,
                       "approve_status": product[0].approve_status,
                       "updated_date": product[0].updated_date,
                       "updated_by": product[0].updated_by,
                       "updated_ip": product[0].updated_ip,
                       "productimage": product[0].productimage,
                       "qty" : "0"
        
    ]
    return productInfo as! [String : String]
}

public func itemFromViewProduct(product : [ViewProductResult]) -> [String:String]{
    
    
    let productInfo = ["id": product[0].id,
                       "hsn_code": product[0].hsn_code,
                       "pdt_code": product[0].pdt_code,
                       "category": product[0].category,
                       "sub_category": product[0].sub_category,
                       "pdt_name": product[0].pdt_name,
                       "pdt_name_tamil": product[0].pdt_name_tamil,
                       "pdt_description": product[0].pdt_description,
                       " pdt_unit": product[0].pdt_unit,
                       "pdt_type": product[0].pdt_type,
                       "pdt_barcode": product[0].pdt_barcode,
                       "pdt_price": product[0].pdt_price,
                       "selling_price": product[0].selling_price,
                       "mrp": product[0].mrp,
                       "disc": product[0].disc,
                       "cgst": product[0].cgst,
                       "sgst": product[0].sgst,
                       "available": product[0].available,
                       "batch": product[0].batch,
                       "profile_picture": product[0].profile_picture,
                       "gst_slab": product[0].gst_slab,
                       "cmp_commission": product[0].cmp_commission,
                       "selling_percent": product[0].selling_percent,
                       "warehouse_percent": product[0].warehouse_percent,
                       "unit_percent": product[0].unit_percent,
                       "unit_sales_price": product[0].unit_sales_price,
                       "wh_sales_price": product[0].wh_sales_price,
                       "status": product[0].status,
                       "visible": product[0].visible,
                       "barcode_status":product[0].barcode_status,
                       "approve_status": product[0].approve_status,
                       "updated_date": product[0].updated_date,
                       "updated_by": product[0].updated_by,
                       "updated_ip": product[0].updated_ip,
                       "productimage": product[0].productimage,
                       "qty" : "0"
        
    ]
    return productInfo as! [String : String]
}

public func itemFromJsonObject(product : [JSON]) -> [String:String]{
    let productInfo = ["id": "\(product[0][ProductInfo.id.rawValue])",
                       "hsn_code": "\(product[0][ProductInfo.hsn_code.rawValue])",
                       "pdt_code":"\( product[0][ProductInfo.pdt_code.rawValue])",
                       "category": "\(product[0][ProductInfo.category.rawValue])",
                       "sub_category": "\(product[0][ProductInfo.sub_category.rawValue])",
                       "pdt_name": "\(product[0][ProductInfo.pdt_name.rawValue])",
                       "pdt_name_tamil": "\(product[0][ProductInfo.pdt_name_tamil.rawValue])",
                       "pdt_description": "\(product[0][ProductInfo.pdt_description.rawValue])",
                       " pdt_unit": "\(product[0][ProductInfo.pdt_unit.rawValue])",
                       "pdt_type": "\(product[0][ProductInfo.pdt_type.rawValue])",
                       "pdt_barcode": "\(product[0][ProductInfo.pdt_barcode.rawValue])",
                       "pdt_price": "\(product[0][ProductInfo.pdt_price.rawValue])",
                       "selling_price": "\(product[0][ProductInfo.selling_price.rawValue])",
                       "mrp": "\(product[0][ProductInfo.mrp.rawValue])",
                       "disc": "\(product[0][ProductInfo.disc.rawValue])",
                       "cgst": "\(product[0][ProductInfo.cgst.rawValue])",
                       "sgst": "\(product[0][ProductInfo.sgst.rawValue])",
                       "available": "\(product[0][ProductInfo.available.rawValue])",
                       "batch": "\(product[0][ProductInfo.batch.rawValue])",
                       "profile_picture": "\(product[0][ProductInfo.profile_picture.rawValue])",
                       "gst_slab": "\(product[0][ProductInfo.gst_slab.rawValue])",
                       "cmp_commission": "\(product[0][ProductInfo.cmp_commission.rawValue])",
                       "selling_percent": "\(product[0][ProductInfo.selling_percent.rawValue])",
                       "warehouse_percent": "\(product[0][ProductInfo.warehouse_percent.rawValue])",
                       "unit_percent": "\(product[0][ProductInfo.unit_percent.rawValue])",
                       "unit_sales_price": "\(product[0][ProductInfo.unit_sales_price.rawValue])",
                       "wh_sales_price": "\(product[0][ProductInfo.wh_sales_price.rawValue])",
                       "status": "\(product[0][ProductInfo.status.rawValue])",
                       "visible": "\(product[0][ProductInfo.visible.rawValue])",
                       "barcode_status": "\(product[0][ProductInfo.barcode_status.rawValue])",
                       "approve_status": "\(product[0][ProductInfo.approve_status.rawValue])",
                       "updated_date": "\(product[0][ProductInfo.updated_date.rawValue])",
                       "updated_by": "\(product[0][ProductInfo.updated_by.rawValue])",
                       "updated_ip": "\(product[0][ProductInfo.updated_ip.rawValue])",
                       "productimage": "\(product[0][ProductInfo.productimage.rawValue])",
                       "qty" : "0"
        
        ] as [String : Any]
    return productInfo as! [String : String]
}

