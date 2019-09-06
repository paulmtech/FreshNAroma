//
//  CheckoutPageViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 12/06/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Razorpay
class CheckoutPageViewController: UIViewController,NVActivityIndicatorViewable,RazorpayPaymentCompletionProtocol ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblDeliveryCharge: UILabel!
    
    @IBOutlet weak var viewTotal: UIView!
    @IBOutlet weak var lblFinalTotal: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
    @IBOutlet weak var viewAddress: UIView!
    
    @IBOutlet weak var lblTotalSave: UILabel!
    @IBOutlet weak var lblPayable: UILabel!
    @IBOutlet weak var lblOnLinePayment: UILabel!
    @IBOutlet weak var btnOnLinePayment: UIButton!
    @IBOutlet weak var lblCashOnDeliver: UILabel!
    @IBOutlet weak var btnCashOnDelivery: UIButton!
    @IBOutlet weak var lblUseWallet: UILabel!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var lblWalletPoint: UILabel!
    
    @IBOutlet weak var viewWallet: UIView!
    
    @IBOutlet weak var viewFinalTotal: UIView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    var userData = [String : String]()
    let checkBox = UIImage(named: "checkBox") as UIImage?
    let unCheckBox = UIImage(named: "uncheckBox") as UIImage?
    var dictPament = [String : Any]()
    var orderTotal = String()
    var finalTotalValue = Float()
    var remaningTotalValue = Float()
    var floatWalletPoint = Float()
    var isWalletused = Bool()
    var paymentType = String()
    var floatUsedWallet = Float()
    var paymentTransactionID = String()
    var freshPaymentViewController = PaymentRazorViewController()
    var email = String ()
    var contactNumber = String()
    var isUpdateAddress = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        viewAddress = setViewBorder(view: viewAddress, bradious: 5, bwidth: 1, bcolor: UIColor.lightGray)
        viewTotal = setViewBorder(view: viewTotal, bradious: 5, bwidth: 1, bcolor: UIColor.lightGray)
        viewPayment = setViewBorder(view: viewPayment, bradious: 5, bwidth: 1, bcolor: UIColor.lightGray)
        viewWallet = setViewBorder(view: viewWallet, bradious: 5, bwidth: 1, bcolor: UIColor.lightGray)
        viewFinalTotal = setViewBorder(view: viewFinalTotal, bradious: 5, bwidth: 1, bcolor: UIColor.lightGray)
        showTotalView()
        showSavedAmount()
        paymentType = ""
        paymentTransactionID = ""
        contactNumber = ""
        email = ""
        isUpdateAddress = false
        getUserinformation()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
        btnSubmit.isUserInteractionEnabled = true
        
    }
    @objc func onDidReceiveData(_ notification:Notification) {
        
         isUpdateAddress = true
         getUserinformation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        }


    func showSavedAmount() {
        let savedAmount = dictPament["saved"] as! String
        guard let floatSavedAmount = Float(savedAmount) else {
            lblTotalSave.isHidden = true
            return
        }
        if floatSavedAmount > Float(0) {
            lblTotalSave.text = String(format: "Your Total Saving: \(RupeeSymbol)%.2f", floatSavedAmount)
        }
    }
    
    func showTotalView(){
        orderTotal = dictPament["total"] as! String
        lblOrderTotal.text = String(format: "Order Total: \(RupeeSymbol)%@",orderTotal)
        guard var floatOrderTotal = Float(orderTotal) else {
            return
        }
        if floatOrderTotal < Float(1000.00) {
            floatOrderTotal += Float(20)
            lblFinalTotal.text = String(format: "Final Total: \(RupeeSymbol)%.2f",floatOrderTotal)
            finalTotalValue = floatOrderTotal
        }else {
             finalTotalValue = floatOrderTotal
             lblFinalTotal.removeFromSuperview()
             lblDeliveryCharge.removeFromSuperview()
        }
    }
    
    func deliveryAddress(userinfo: UserInfoRootClass) -> String{
         let  address1 =  userinfo.CustomerInfo[0].shipping_address!
         let  address2 = userinfo.CustomerInfo[0].shipping_address2!
         let city = userinfo.CustomerInfo[0].city!
         let state = userinfo.CustomerInfo[0].state!
         let country = userinfo.CustomerInfo[0].country!
         let pincode = userinfo.CustomerInfo[0].pin_code!
        
         let shippingAddress1 = address1.count > 0 ? "\(address1)," : ""
         let shippingAddress2 = address2.count > 0 ? "\(address2)," : ""
         let shippingcity = city.count > 0 ? "\(city)," : ""
         let shippingstate = state.count > 0 ? "\(state)," : ""
         let shippingcountry = country.count > 0 ? "\(country)," : ""
         let shippingpincode = pincode.count > 0 ? "\(pincode)" : ""
         let addressString = "\(shippingAddress1) \(shippingAddress2)\(shippingcity)\(shippingstate)\(shippingcountry)\(shippingpincode)"
        
    return  addressString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    
    
    func openProfileView () {
        
        let storyBoardId =  "UpdateProfile"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! ProfileViewController
        nextViewControler.viewPresentType = "Present"
        self.present(nextViewControler, animated: true, completion: nil)
    }
    
    
    fileprivate func getUserinformation() {
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
          let  userID =  (userCode![UserDefaulKey.code]! as? String)!
            
            if userID.count == 0 {
                // let response_msg = responsValue.Response[0].response_msg
                let alertVc = UIAlertController(title: "", message: "New user! Kindly Register", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                    
                    let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
                    self.present(nextViewControler!, animated: true)
                }))
                self.present(alertVc, animated: true, completion: nil)
            }else{
                getUserInfo(customerid: userID)
            }
        }
    }
    
    func getUserInfo(customerid: String){
        self.view.endEditing(true)
        
        startAnimating()
        let api = APIRequestFetcher()
        let dictionary = ["MyProfile":["code": customerid]]
        api.fetchApiResult(viewController: self, paramDict: dictionary)
        { (result : UserInfoRootClass, error) in
            DispatchQueue.main.async {
                self.stopAnimating()
                }
            
            if case .success = error {
                DispatchQueue.main.async {
                    let result = result
                    if self.isUpdateAddress {
                       self.updateAddress(userinfo: result)
                    }else {
                    self.setUserInfor(userinfo: result)
                    }
                   }
            }
            
        }
    }
    
    func showWalletView(wPoint: String ){
        
        guard let walletPoint = Float(wPoint) else {
            return
        }
        
        if walletPoint > 0.0 {
           floatWalletPoint = walletPoint
        if finalTotalValue <= walletPoint {
            floatUsedWallet = finalTotalValue
            print("1 wallet==\(floatUsedWallet)")
            remaningTotalValue = 0.0
            isWalletused = true
            paymentType = "0"
            btnCashOnDelivery.setImage(unCheckBox, for: .normal)
            lblCashOnDeliver.text = "Cash on delivery"
            btnOnLinePayment.setImage(unCheckBox, for: .normal)
            lblOnLinePayment.text = "Online payment"
            lblUseWallet.text = String(format: "Debited from wallet: \(RupeeSymbol)%.2f",finalTotalValue)
        }else {
            remaningTotalValue = finalTotalValue - walletPoint
            isWalletused = false
            lblUseWallet.text = String(format: "Debited from wallet: \(RupeeSymbol)%.2f",walletPoint)
            floatUsedWallet = walletPoint
             print("2 wallet==\(floatUsedWallet)")
        }
            lblWalletPoint.text = String(format: "Wallet Point: \(RupeeSymbol)%.2f", walletPoint)
            btnWallet.setImage(checkBox, for: .normal)
            
        }else {
              floatUsedWallet = 0.0
             print("3 wallet==\(floatUsedWallet)")
              remaningTotalValue = finalTotalValue
              viewWallet.removeFromSuperview()
        }
       
    }
    
    func  updateAddress(userinfo: UserInfoRootClass)  {
      lblDeliveryAddress.text = deliveryAddress(userinfo: userinfo)
      let key = UserInformationDefaultKey()
      lblDeliveryAddress.text = deliveryAddress(userinfo: userinfo)
        email = userinfo.CustomerInfo[0].email_address
        contactNumber = userinfo.CustomerInfo[0].contact
        userData =     [key.code : userinfo.CustomerInfo[0].code,
                        key.first_name : userinfo.CustomerInfo[0].first_name,
                        key.last_name : userinfo.CustomerInfo[0].last_name,
                        key.contact: userinfo.CustomerInfo[0].contact,
                        key.email_address : userinfo.CustomerInfo[0].email_address,
                        key.shipping_address : userinfo.CustomerInfo[0].shipping_address,
                        key.shipping_address2 : userinfo.CustomerInfo[0].shipping_address2,
                        key.city : userinfo.CustomerInfo[0].city,
                        key.state : userinfo.CustomerInfo[0].state,
                        key.country : userinfo.CustomerInfo[0].country,
                        key.pin_code : userinfo.CustomerInfo[0].pin_code,
                        
                        key.bill_first_name : userinfo.CustomerInfo[0].bill_first_name,
                        key.bill_last_name : userinfo.CustomerInfo[0].bill_last_name,
                        key.bill_contact : userinfo.CustomerInfo[0].bill_contact,
                        key.bill_email_address : userinfo.CustomerInfo[0].bill_email_address,
                        key.bill_address: userinfo.CustomerInfo[0].bill_address,
                        key.bill_address2 : userinfo.CustomerInfo[0].bill_address2,
                        key.bill_city : userinfo.CustomerInfo[0].bill_city,
                        key.bill_state : userinfo.CustomerInfo[0].bill_state,
                        key.bill_country : userinfo.CustomerInfo[0].bill_country,
                        key.bill_pin_code : userinfo.CustomerInfo[0].bill_pin_code]
        UserDefaults.standard.set(userData, forKey: UserDefaulKey.userdict)
    }
    
    func setUserInfor(userinfo: UserInfoRootClass)  {
        
        let key = UserInformationDefaultKey()
        let walletPoint = userinfo.CustomerInfo[0].wallet_point
        lblDeliveryAddress.text = deliveryAddress(userinfo: userinfo)
        email = userinfo.CustomerInfo[0].email_address
        contactNumber = userinfo.CustomerInfo[0].contact
        showWalletView(wPoint: walletPoint ?? "0" )
         userData =     [key.code : userinfo.CustomerInfo[0].code,
                        key.first_name : userinfo.CustomerInfo[0].first_name,
                        key.last_name : userinfo.CustomerInfo[0].last_name,
                        key.contact: userinfo.CustomerInfo[0].contact,
                        key.email_address : userinfo.CustomerInfo[0].email_address,
                        key.shipping_address : userinfo.CustomerInfo[0].shipping_address,
                        key.shipping_address2 : userinfo.CustomerInfo[0].shipping_address2,
                        key.city : userinfo.CustomerInfo[0].city,
                        key.state : userinfo.CustomerInfo[0].state,
                        key.country : userinfo.CustomerInfo[0].country,
                        key.pin_code : userinfo.CustomerInfo[0].pin_code,
                        
                        key.bill_first_name : userinfo.CustomerInfo[0].bill_first_name,
                        key.bill_last_name : userinfo.CustomerInfo[0].bill_last_name,
                        key.bill_contact : userinfo.CustomerInfo[0].bill_contact,
                        key.bill_email_address : userinfo.CustomerInfo[0].bill_email_address,
                        key.bill_address: userinfo.CustomerInfo[0].bill_address,
                        key.bill_address2 : userinfo.CustomerInfo[0].bill_address2,
                        key.bill_city : userinfo.CustomerInfo[0].bill_city,
                        key.bill_state : userinfo.CustomerInfo[0].bill_state,
                        key.bill_country : userinfo.CustomerInfo[0].bill_country,
                        key.bill_pin_code : userinfo.CustomerInfo[0].bill_pin_code]
        UserDefaults.standard.set(userData, forKey: UserDefaulKey.userdict)
        
    }
    
    //  Mark: -    Button Actions
    @IBAction func didBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didPressedSubmitButton(_ sender: Any) {
        
        paymentCheck()
        
        if lblDeliveryAddress.text!.count > 0 {
            if isWalletused && remaningTotalValue <= 0 {
             placeOrder()
            }else{
                if (paymentType == "0") {
                    let alert = UIAlertController(title: "Select Payment Type", message: "", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                } else if  (paymentType == "0") || (paymentType == "1" && remaningTotalValue > 0.0){
                    let alert = UIAlertController(title: "Select Payment Type", message: "Remaining amount to be Pay: \(RupeeSymbol)\(remaningTotalValue)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
                
                
                else {
                    // local = rzp_test_W57UXqJ4CJnQwc
                    // live = rzp_live_RSo6ifr3caLLnh
                   
                    if paymentType == "4" || paymentType == "5"{
                        btnSubmit.isUserInteractionEnabled = false
                        var amount = remaningTotalValue
                        print("payment value == \(amount)")
                       amount = amount * 100.00;
                        let options: [String:Any] = [
                            "amount" : amount as Any, //mandatory in paise
                            "description": "Amount Payable",
                            "image": "http://www.freshnaroma.com/img/logo_pay.png",
                            "name": "FRESH N AROMA",
                            "prefill": [
                                "contact": contactNumber,
                                "email": email
                            ],
                            "theme": [
                                "color": "#F7C233"
                            ]
                        ]
                        
                        let razorpay: Razorpay!
                        razorpay = Razorpay.initWithKey(RazorPayAppKey.liveKey.rawValue, andDelegate: self)

                        razorpay.open(options, displayController: self)
                    }else{
                    placeOrder()
                    }
                }
            }
            
        }else {
            
            let alert = UIAlertController(title: "Enter Delivery Address", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.openProfileView()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
            
        }
        
    }
    @IBAction func didEditButtonPressed(_ sender: Any) {
        openProfileView()
    }
    
    @IBAction func didPressedWalletButton(_ sender: UIButton) {
        btnSubmit.isUserInteractionEnabled = true
        if sender.currentImage == checkBox{
            sender.setImage(unCheckBox, for: .normal)
             remaningTotalValue = finalTotalValue
             lblUseWallet.text = "Use Wallet"
             floatUsedWallet = 0.0
             print("4 wallet==\(floatUsedWallet)")
            
        }else {
            sender.setImage(checkBox, for: .normal)
            showWalletView(wPoint: "\(floatWalletPoint)")
            //remaningTotalValue = finalTotalValue - floatWalletPoint
            
        }
        if btnCashOnDelivery.currentImage == checkBox{
            
            lblCashOnDeliver.text = String(format: "Cash on delivery: \(RupeeSymbol)%.2f ", remaningTotalValue)
            }
        else if btnOnLinePayment.currentImage == checkBox {
            lblOnLinePayment.text = String(format: "Online payment: \(RupeeSymbol)%.2f ", remaningTotalValue)
        }
        
    }
    @IBAction func didPressedCashOnDelivery(_ sender: UIButton) {
        btnSubmit.isUserInteractionEnabled = true
        if sender.currentImage == checkBox {
            sender.setImage(unCheckBox, for: .normal)
             lblCashOnDeliver.text = "Cash on delivery"
        }else {
            if remaningTotalValue <= 0.0 {
                btnWallet.setImage(unCheckBox, for: .normal)
                lblUseWallet.text = "Use Wallet"
                remaningTotalValue = finalTotalValue
                
            }

            lblCashOnDeliver.text = String(format: "Cash on delivery: \(RupeeSymbol)%.2f ", remaningTotalValue)
            sender.setImage(checkBox, for: .normal)
            btnOnLinePayment.setImage(unCheckBox, for: .normal)
            lblOnLinePayment.text = "Online payment"
        }
    }
    
    @IBAction func didPressedOnLinePaymentButton(_ sender: UIButton) {
        if sender.currentImage == checkBox {
            sender.setImage(unCheckBox, for: .normal)
            lblOnLinePayment.text = "Online payment"
        }else {
            if remaningTotalValue <= 0.0 {
                btnWallet.setImage(unCheckBox, for: .normal)
                lblUseWallet.text = "Use Wallet"
                remaningTotalValue = finalTotalValue
            }
            sender.setImage(checkBox, for: .normal)
            btnCashOnDelivery.setImage(unCheckBox, for: .normal)
            lblOnLinePayment.text = String(format: "Online payment: \(RupeeSymbol)%.2f ", remaningTotalValue)
            lblCashOnDeliver.text = "Cash on delivery"
        }
    }
    
    func paymentUnCheck() {
        
    }
    
    func paymentCheck() {
        
        if btnWallet.currentImage == checkBox && btnOnLinePayment.currentImage == checkBox {
            paymentType = "4"
        } else if btnWallet.currentImage == checkBox && btnCashOnDelivery.currentImage == checkBox {
             paymentType = "3"
        } else if btnOnLinePayment.currentImage == checkBox {
             floatUsedWallet = 0.0
             print("5 wallet==\(floatUsedWallet)")
             paymentType = "5"
        } else  if btnCashOnDelivery.currentImage == checkBox {
            floatUsedWallet = 0.0
             print("6 wallet==\(floatUsedWallet)")
             paymentType = "2"
        } else if btnWallet.currentImage == checkBox {
           paymentType = "1"
        } else {
             paymentType = "0"
        }
        
    }
    
    

    func placeOrder() {
        
        let pid = dictPament["pid"]!
        let qty = dictPament["qty"]!
        let p_pid = (pid as AnyObject).componentsJoined(by: ",")
        let p_qty = (qty as AnyObject).componentsJoined(by: ",")
        let firstname = userData["first_name"]!
        let lastname = userData["last_name"]!
        let contact  =  userData["contact"]!
        let emailaddress = userData["email_address"]!
        let country = userData["country"]!
        let state = userData["state"]!
        let city = userData["city"]!
        let pincode = userData["pin_code"]!
        let shippingaddress = userData["shipping_address"]!
        let shippingaddress2 = userData["shipping_address2"]!
        
        let bill_firstname = userData["bill_first_name"]!
        let bill_lastname = userData["bill_last_name"]!
        let bill_country = userData["bill_country"]!
        let bill_state = userData["bill_state"]!
        let bill_city = userData["bill_city"]!
        let bill_pin_code = userData["bill_pin_code"]!
        let bill_address = userData["bill_address"]!
        let bill_address2 = userData["bill_address2"]!
        let code = userData["code"]!
        let type = paymentType
        let transactionid = paymentTransactionID
        let net_amount = remaningTotalValue
        let wallet_use = "\(floatUsedWallet)"
        print("placeorder wallet==\(wallet_use ) Paid Amount = \(net_amount)")
        
        let dictionary: [String : Any] = [
            "Checkout": ["products" : ["pid" : p_pid ,"qty":p_qty ,"sessionid" : sessionId!,"user_mode" : "iOS","code": code],"customer" :["first_name": firstname ,"last_name" : lastname,"contact" : contact,"email_address" : emailaddress,"country" : country,"state" : state,"city" : city,"pin_code" : pincode,"shipping_address" : shippingaddress,"shipping_address2" : shippingaddress2,"bill_first_name" : bill_firstname,"bill_last_name" : bill_lastname,"bill_country" : bill_country,"bill_state" : bill_state,"bill_city" : bill_city,"bill_pin_code" : bill_pin_code,"bill_address" : bill_address,"bill_address2" : bill_address2],"payment" : ["type": type,"transactionid":transactionid ,"net_amount" : net_amount,"wallet_use" : wallet_use ]
            ]]
//        print("Transation id = \(transactionid), Remaining payment \(remaningTotalValue)")
         print(dictionary)
       let data = try! JSONSerialization.data(withJSONObject: dictionary)
        let base64Representation = data.base64EncodedString()
        let longstring = authParameter()!
        let qry = "Case=\(base64Representation)"
        let jsonUrlString = "\(baseUrl)\(longstring)&\(String(describing: qry))"
        print("URL RESULT with normal \(jsonUrlString)")
        
        let escapedString = jsonUrlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        let url = URL(string: escapedString!)
        print("URL RESULT with encap \(url as Any)")
        startAnimating()
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            DispatchQueue.main.async {
                self.stopAnimating()
            }
            guard let data = data else {
                return
            }
            do {
                
                let responsValue = try JSONDecoder().decode(CheckoutRootClass.self, from: data)
                
                if responsValue.Response[0].response_code == "1"{
                     DispatchQueue.main.async {
                    let homeScreen = OrderCompleteViewController(nibName: "OrderCompleteViewController", bundle: nil)
                    self.navigationController!.pushViewController(homeScreen, animated: true)
                    }
                }else {
                    let alertController = UIAlertController(title: "Order Placed error" , message: responsValue.Response[0].response_msg, preferredStyle: UIAlertController.Style.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            catch let error {
                let alertController = UIAlertController(title: "Order Placed error" , message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
              
            }
        }
        
        task.resume()
}
    
    func onPaymentError(_ code: Int32, description str: String) {
        btnSubmit.isUserInteractionEnabled = true
        let alertController = UIAlertController(title: "PAYMENT" , message: "FAILURE", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        paymentTransactionID = payment_id
        let alertController = UIAlertController(title: "PAYMENT", message: "SUCCESS", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            DispatchQueue.main.async {
               self.placeOrder()
            }
            
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
public struct CheckoutRootClass : Decodable {
    
   // public var BillInfo : [CheckoutBillInfo]!
    public var Response : [CheckoutResponse]!
    
}
public struct CheckoutResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct CheckoutBillInfo : Decodable {
    public var amount : String!
    public var bill_no : String!
    public var bill_save : String!
    public var created_date : String!
    public var cus_name : String!
    public var customer_id : String!
    public var deliver_mobile : String!
    public var deliver_person : String!
    public var delivery_charge : String!
    public var delivery_remarks : String!
    public var delivery_status : String!
    public var id : String!
    public var mobile : String!
    public var net_amt : String!
    public var order_type : String!
    public var otp : String!
    public var payment_type : String!
    public var product_name : String!
    public var products : String!
    public var qty : String!
    public var totalamount : Int!
    public var transactionid : String!
   // public var unit : Any?
    public var used_redeem_point : String!
    public var user_mode : String!
    }
