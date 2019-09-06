//
//  ViewOrderViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 03/01/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import NVActivityIndicatorView

class ViewOrderViewController: UIViewController, NVActivityIndicatorViewable ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var invoiceno = String()
    
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view11: UIView!
    
    @IBOutlet weak var viewWalletUsed: UIView!
    @IBOutlet weak var viewCashOnDelivery: UIView!
    
    @IBOutlet weak var lblcashOnDelivery: UILabel!
    @IBOutlet weak var lblWallerUsed: UILabel!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var lblinvoiceno: UILabel!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
   
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    
    @IBOutlet weak var lblMRP: UILabel!
    
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblNetAmount: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    
    @IBOutlet weak var lblShippingAddress: UILabel!
    @IBOutlet weak var lblBillingAddress: UILabel!
    
    
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblContactnumber: UILabel!
   
    
fileprivate func setviewlayerdesing(view: UIView) {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let billNo = UserDefaults.standard.value(forKey: "bill_no")
        getviewOrders(invoiceNumber: billNo as! String)
        setviewlayerdesing(view: view11)
        setviewlayerdesing(view: view12)
        
        setviewlayerdesing(view: view13)
        setviewlayerdesing(view: viewPayment)
       
       api.delegate = self

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
      
    }

    @IBAction func didPressedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    fileprivate func showViewOrder(_ responsValue: ViewbillRootClass) {
        
        
        self.lblinvoiceno.text =  "#\( responsValue.BillInfo!.Invoice!.Number!)"
        self.lblName.text = responsValue.BillInfo!.Customer?.Name
        self.lblContactnumber.text = responsValue.BillInfo!.Customer?.Mobile
        let date = responsValue.BillInfo!.Invoice!.Date
        
        self.lblDate.text = "\(getDateFromString(dateStr: date!))"
        
        let stringdelveryCharge = responsValue.BillInfo!.Payment!.DeliveryCharge!
      
        self.lblPaymentType.text = "\(responsValue.BillInfo!.Payment!.PaymentType!)"
        if  self.lblPaymentType.text == "Wallet / Cash on Delivery" {
            self.lblWallerUsed.text = responsValue.BillInfo!.Payment!.RedeemPoints!
            let cashondelivery = floatFromString(stringValue: responsValue.BillInfo!.Payment!.NetAmount!)-floatFromString(stringValue: responsValue.BillInfo!.Payment!.RedeemPoints!)
            self.lblcashOnDelivery.text = "\(cashondelivery)"
        }else {
           self.viewCashOnDelivery.isHidden = true
            self.viewWalletUsed.isHidden = true
        }
        if stringdelveryCharge == "0"{
             self.lblDeliveryCharge.text = " Free"
            
        } else {
             self.lblDeliveryCharge.text = "\(RupeeSymbol)\(responsValue.BillInfo!.Payment!.DeliveryCharge!)"
        }
        let products = responsValue.BillInfo!.Products!
        self.lblMRP.text =  "\(products.count)"
        if floatFromString(stringValue:  responsValue.BillInfo!.Payment!.Discount!) != 0 {
        
        //self.lblTotalDiscount.text = ": \(RupeeSymbol)\(responsValue.BillInfo!.Payment!.Discount!)"
        }else {
           }
        
        self.lblNetAmount.text = "\(RupeeSymbol)\(responsValue.BillInfo!.Payment!.NetAmount!)"
        self.lblOrderTotal.text = "\(RupeeSymbol)\(String(describing: responsValue.BillInfo!.Payment!.GrantTotal!))"
        
        let baddress1 = responsValue.BillInfo!.Customer?.Billing!.Address1!
        let baddress2 = responsValue.BillInfo!.Customer?.Billing!.Address2!
        let bcity = responsValue.BillInfo!.Customer?.Billing!.City!
        
        let billingAddress1 = baddress1!.count > 0 ? "\(baddress1!)," : ""
        let billingAddress2 = baddress2!.count > 0 ? "\(baddress2!)," : ""
        let billingcity = bcity!.count > 0 ? "\(bcity!)," : ""
        let billingstate = responsValue.BillInfo!.Customer!.Billing!.State!.count > 0 ? "\(responsValue.BillInfo!.Customer!.Billing!.State!)," : ""
        //let billingcountry = responsValue.BillInfo!.Customer!.Billing!..count > 0 ? "\(userinfo.CustomerInfo[0].bill_country!)," : ""
        let billingpincode = responsValue.BillInfo!.Customer!.Billing!.Pincode!.count > 0 ? "\(responsValue.BillInfo!.Customer!.Billing!.Pincode!)" : ""
        
        lblBillingAddress.text = "\(billingAddress1) \(billingAddress2)\(billingcity)\(billingstate)\(billingpincode)"
        let saddress1 = responsValue.BillInfo!.Customer?.Delivery!.Address1!
        let saddress2 = responsValue.BillInfo!.Customer?.Delivery!.Address2!
        
        let shippingAddress1 = saddress1!.count > 0 ? "\(saddress1!)," : ""
        let shippingAddress2 = saddress2!.count > 0 ? "\(saddress2!)," : ""
        let shippingcity = responsValue.BillInfo!.Customer!.Delivery!.City!.count > 0 ? "\(responsValue.BillInfo!.Customer!.Delivery!.City!)," : ""
        let shippingstate = responsValue.BillInfo!.Customer!.Delivery!.State!.count > 0 ? "\(responsValue.BillInfo!.Customer!.Delivery!.State!)," : ""
        //let shippingcountry = userInfo.CustomerInfo[0].country.count > 0 ? "\(userinfo.CustomerInfo[0].country!)," : ""
        let shippingpincode = responsValue.BillInfo!.Customer!.Delivery!.Pincode!.count > 0 ? "\(responsValue.BillInfo!.Customer!.Delivery!.Pincode!)" : ""
        
     
        
//        let deliveryAddress = "\(responsValue.BillInfo!.Customer?.Delivery!.Address1! ?? ""),\(responsValue.BillInfo!.Customer?.Delivery!.Address2! ?? ""),\(responsValue.BillInfo!.Customer!.Delivery!.City! ),\(responsValue.BillInfo!.Customer!.Delivery!.State!),\(responsValue.BillInfo!.Customer!.Delivery!.Pincode!)"
        
        self.lblBillingAddress.text = "\(billingAddress1) \(billingAddress2)\(billingcity)\(billingstate)\(billingpincode)"
        self.lblShippingAddress.text = "\(shippingAddress1) \(shippingAddress2)\(shippingcity)\(shippingstate)\(shippingpincode)"
    }
    
    func getviewOrders(invoiceNumber: String){
        
            startAnimating()
            let dictionary = ["ViewBill":["invoiceno":"\(invoiceNumber)"]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : ViewbillRootClass, error) in
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response![0].response_code == "1"{
                            
                            self.showViewOrder(responsValue)
                        }
                        
                        
                    }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: result.Response![0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        
                        
                        let alertVc = UIAlertController(title: "", message: Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
        
        
    }
    


}

    
   


//MAKE: - Decodable
public struct ViewbillRootClass : Decodable {
    
    public var BillInfo : ViewbillBillInfo?
    public var Response : [ViewbillResponse]?
    
}
public struct ViewbillResponse: Decodable {
    
    public var response_code : String?
    public var response_msg : String?
    
}


public struct ViewbillBillInfo : Decodable {
    
    public var Customer : ViewbillCustomer?
    public var Invoice : ViewbillInvoice?
    public var Payment : ViewbillPayment?
    public var Products : [ViewbillProduct]?
    
}

public struct ViewbillProduct : Decodable {
    
    public var Discount : String?
    public var MRP : String?
    public var Name : String?
    public var ProductImage : String?
    public var Quantity : String?
    public var SellingPrice : String?
    public var Total : String?
    
}

public struct ViewbillPayment : Decodable {
    
    public var Discount : String?
    public var NetAmount : String?
    public var RedeemPoints : String?
    public var TotalAmount : String?
    public var TransactionID : String?
    public var PaymentType : String?
    public var DeliveryCharge : String?
    public var GrantTotal : String?
    
}



public struct ViewbillInvoice : Decodable {
    
    public var Date : String?
    public var Number : String?
    
}

public struct ViewbillCustomer: Decodable {
    
    public var Billing : ViewbillBilling?
    public var Delivery : ViewbillDelivery?
    public var Mobile : String?
    public var Name : String?
    
}

public struct ViewbillDelivery:Decodable {
    
    public var Address1 : String?
    public var Address2 : String?
    public var City : String?
    public var Pincode : String?
    public var State : String?
    
}

public struct ViewbillBilling :Decodable {
    
    public var Address1 : String?
    public var Address2 : String?
    public var City : String?
    public var Pincode : String?
    public var State : String?
    
}


