//
//  TrackOrderViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 04/01/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import NVActivityIndicatorView

class TrackOrderViewController: UIViewController,NVActivityIndicatorViewable ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
var invoiceno = String()
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPaymenyType: UILabel!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var imgTrackLine1: UIImageView!
    @IBOutlet weak var imgTrackLine2: UIImageView!
    @IBOutlet weak var imgTrack5: UIImageView!
    @IBOutlet weak var imgTrackLine4: UIImageView!
    @IBOutlet weak var imgTrack4: UIImageView!
    @IBOutlet weak var imgTrack3: UIImageView!
    @IBOutlet weak var imgTrackLine3: UIImageView!
    @IBOutlet weak var imgTrack2: UIImageView!
    @IBOutlet weak var imgTrack1: UIImageView!
    @IBOutlet weak var lblConfirmed: UILabel!
    @IBOutlet weak var lblDelivered: UILabel!
    @IBOutlet weak var lblOutofDelivery: UILabel!
    @IBOutlet weak var lblPacked: UILabel!
    @IBOutlet weak var lblAccepted: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        "Order Placed\nWe have recevied your order.",
 // lblConfirmed.text = "Order Confirmed\nYour order has been confirmed"
 // lblAccepted.text = "Order Accepted\nYour order has been Accepted"
  //lblPacked.text =  "Order Packed\nwe are perparing your order."
        api.delegate = self
        trackOrder(invoiceNo: invoiceno)
       lblOutofDelivery.text = "Out Of Delivery"
       lblDelivered.text = "Delivered"
 
//  lblConfirmed.attributedText = setattributedString(chagestring: "Order Placed.", range: NSRange(location: 0, length: 12))
//  lblAccepted.attributedText = setattributedString(chagestring: "Accepted.", range: NSRange(location: 0, length: 10))
//  lblPacked.attributedText = setattributedString(chagestring: "Packed.", range: NSRange(location: 0, length: 12))
//   lblOutofDelivery.attributedText = setattributedString(chagestring: "Out for Delivery.", range: NSRange(location: 0, length: 16))
//        lblDelivered.attributedText = setattributedString(chagestring: "Delivered.", range: NSRange(location: 0, length: 10))
//        "Ready to pickup\nYour order is ready for pickup",
        // Do any additional setup after loading the view.
    }
    
    func setattributedString(chagestring : String,range : NSRange) -> NSMutableAttributedString {
       // let myRange = NSRange(location: 0, length: 19)
        let anotherAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.gray ,NSAttributedString.Key.font: UIFont(name: "Helvetica neue", size: 14.0)!]
        let myString = NSMutableAttributedString(string: chagestring)
        myString.addAttributes(anotherAttribute, range: range)
        return myString
    }
    @IBAction func didPressedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    func trackOrder(invoiceNo: String){
       
            startAnimating()
             let dictionary = ["TrackOrder": ["invoiceno":invoiceNo]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : TrackOrderRootClass, error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        
                        let responsValue = result
                        if responsValue.Response[0].response_code == "1"{
                            
                            self.showOrderState(itemInfo: responsValue.BillInfo!)
                            self.showOrderInfo(itemInfo: responsValue.BillInfo!.billinfo![0])
                        }
                        }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
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
    func getQty(qty : String) -> String{
        
        let qtyArray = qty.split(separator: ",")
        return "\(qtyArray.count)"
    }
    func showOrderInfo(itemInfo: TrackOrderBill_info){
        let qty = getQty(qty: "\(itemInfo.qty!)")
        let items = "Items: \(qty)"
        let myRange = NSRange(location: 0, length: 6)
        let anotherAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.gray ,NSAttributedString.Key.font: UIFont(name: "Helvetica neue", size: 18.0)!]
        let myString = NSMutableAttributedString(string: items)
        
        myString.addAttributes(anotherAttribute, range: myRange)
        lblItem.attributedText = myString
        lblDate.text = "\(itemInfo.created_date!)"
        lblTotal.text = "Total: \(RupeeSymbol)\(itemInfo.net_amt!)"
        let paymenttype = "Payment type: \(itemInfo.payment_type!)"
        let aString = NSMutableAttributedString(string: paymenttype)
        let myRange1 = NSRange(location: 0, length: 12)
        aString.addAttributes(anotherAttribute, range: myRange1)
        lblPaymenyType.attributedText =  aString
    }
    
    func showOrderState(itemInfo: TrackOrderBillInfo){
        let imgLine = UIImage(named: "track_Line")
        let imgConfirmed = UIImage(named: "track_confirmed")
        let imgAccepted = UIImage(named: "track_Accepted")
        let imgPacked = UIImage(named: "track_packed")
        let imgOutOfDelivery = UIImage(named: "track_outofdelivery")
        
        let stringConfirm = "Order Confirmed.\n" //\(itemInfo.trackorder![0])" //setattributedString(chagestring: , range: NSRange(location: 16, length: 20))
        let stringAccepted = "Order Accepted.\n)" //setattributedString(chagestring: "Order Accepted.\(itemInfo.created_date!)", range: NSRange(location: 15, length: 20))
        let stringPacked =  "Order Packed.\n)" //setattributedString(chagestring: "Order Packed.\(itemInfo.created_date!)", range: NSRange(location: 13, length: 20))
        let stringOutOfDelivery = "Out Of Delivery.\n)" //setattributedString(chagestring: "Out Of Delivery.\(itemInfo.created_date!)", range: NSRange(location: 16, length: 20))
        let stringDelivered = "Delivered.\n" //setattributedString(chagestring: "Delivered.\(itemInfo.created_date!)", range: NSRange(location: 10, length: 20))
        
        let orderState = itemInfo.billinfo[0].delivery_status
        switch orderState {
        case "0":
            imgTrack1.image = imgConfirmed
            lblConfirmed.textColor = appThemColor
            lblConfirmed.font = lblConfirmed.font.withSize(18)
            lblConfirmed.text = "\(stringConfirm)\(itemInfo.trackorder![0])"
            
            break
        case "1":
            imgTrack1.image = imgConfirmed
            imgTrackLine1.image = imgLine
            imgTrack2.image = imgAccepted
            lblConfirmed.textColor = appThemColor
            lblConfirmed.font = lblConfirmed.font.withSize(18)
            lblAccepted.textColor = appThemColor
            lblAccepted.font = lblAccepted.font.withSize(18)
            lblConfirmed.text = "\(stringConfirm)\(itemInfo.trackorder![0])"
            lblAccepted.text = "\(stringAccepted)\(itemInfo.trackorder![1])"
           
            break
        case "2":
            imgTrack1.image = imgConfirmed
            imgTrackLine1.image = imgLine
            imgTrack2.image = imgAccepted
            imgTrackLine2.image = imgLine
            imgTrack3.image = imgPacked
            lblConfirmed.textColor = appThemColor
            lblConfirmed.font = lblConfirmed.font.withSize(20)
            lblAccepted.textColor = appThemColor
            lblAccepted.font = lblAccepted.font.withSize(20)
            lblPacked.textColor = appThemColor
            lblPacked.font = lblPacked.font.withSize(20)
            lblConfirmed.text = "\(stringConfirm)\(itemInfo.trackorder![0])"
            lblAccepted.text = "\(stringAccepted)\(itemInfo.trackorder![1])"
            lblPacked.text = "\(stringPacked)\(itemInfo.trackorder![2])"
            
            break
        case "3":
            imgTrack1.image = imgConfirmed
            imgTrackLine1.image = imgLine
            imgTrack2.image = imgAccepted
            imgTrackLine2.image = imgLine
            imgTrack3.image = imgPacked
            imgTrackLine3.image = imgLine
            imgTrack4.image = imgOutOfDelivery
            lblConfirmed.textColor = appThemColor
            lblConfirmed.font = lblConfirmed.font.withSize(18)
            lblAccepted.textColor = appThemColor
            lblAccepted.font = lblAccepted.font.withSize(18)
            lblPacked.textColor = appThemColor
            lblPacked.font = lblPacked.font.withSize(18)
            lblOutofDelivery.textColor = appThemColor
            lblOutofDelivery.font = lblOutofDelivery.font.withSize(18)
            lblConfirmed.text = "\(stringConfirm)\(itemInfo.trackorder![0])"
            lblAccepted.text = "\(stringAccepted)\(itemInfo.trackorder![1])"
            lblPacked.text = "\(stringPacked)\(itemInfo.trackorder![2])"
            lblOutofDelivery.text = "\(stringOutOfDelivery)\(itemInfo.trackorder![3])"
            
            break
        case "4":
            imgTrack1.image = imgConfirmed
            imgTrackLine1.image = imgLine
            imgTrack2.image = imgAccepted
            imgTrackLine2.image = imgLine
            imgTrack3.image = imgPacked
            imgTrackLine3.image = imgLine
            imgTrack4.image = imgOutOfDelivery
            imgTrackLine4.image = imgLine
            imgTrack5.image = UIImage(named: "track_delivery")
            lblConfirmed.textColor = appThemColor
            lblConfirmed.font = lblConfirmed.font.withSize(18)
            lblAccepted.textColor = appThemColor
            lblAccepted.font = lblAccepted.font.withSize(18)
            lblPacked.textColor = appThemColor
            lblPacked.font = lblPacked.font.withSize(18)
            lblOutofDelivery.textColor = appThemColor
            lblOutofDelivery.font = lblOutofDelivery.font.withSize(18)
            lblConfirmed.font = lblConfirmed.font.withSize(18)
            lblAccepted.textColor = appThemColor
            lblAccepted.font = lblAccepted.font.withSize(18)
            lblPacked.textColor = appThemColor
            lblPacked.font = lblPacked.font.withSize(18)
            lblOutofDelivery.textColor = appThemColor
            lblOutofDelivery.font = lblOutofDelivery.font.withSize(18)
            lblDelivered.textColor = appThemColor
            lblDelivered.font = lblDelivered.font.withSize(18)
            lblConfirmed.text = "\(stringConfirm)\(itemInfo.trackorder![0])"
            lblAccepted.text = "\(stringAccepted)\(itemInfo.trackorder![1])"
            lblPacked.text = "\(stringPacked)\(itemInfo.trackorder![2])"
            lblOutofDelivery.text = "\(stringOutOfDelivery)\(itemInfo.trackorder![3])"
            lblDelivered.text = "\(stringDelivered)\(itemInfo.trackorder![4])"
            break
            
        default:
            break
        }
    }
    
}
public struct TrackOrderRootClass: Decodable {
    
    public var BillInfo : TrackOrderBillInfo!
    public var Response : [TrackOrderResponse]!
    
}
public struct TrackOrderResponse: Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct TrackOrderBillInfo: Decodable {
    public var billinfo : [TrackOrderBill_info]!
    public var trackorder : [String]!
    
    
}
public struct TrackOrderBill_info : Decodable {
public var  id: String!
public var  unit: String!
public var  bill_no: String!
public var  customer_id: String!
public var  cus_name: String!
public var  mobile: String!
public var  product_name: String!
public var  products: String!
public var qty: String!
public var amount: String!
public var used_redeem_point: String!
public var net_amt: String!
public var bill_save: String!
public var payment_type: String!
public var transactionid: String!
public var delivery_status: String!
public var order_type: String!
public var created_date: String!
}
