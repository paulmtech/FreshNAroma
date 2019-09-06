//
//  WalletViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 17/10/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Razorpay
class WalletViewController: UIViewController,NVActivityIndicatorViewable,RazorpayPaymentCompletionProtocol ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var amount = Int()
    var email = String ()
    var contactNumber = String()
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "PAYMENT" , message: "FAILURE", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        
        let customerid = walletPaymentType == "1" ? customerCode : otherCustomer
        let date = Date()
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let resultString = inputFormatter.string(from: date)
        
        let dict = ["RechargeWallet":["code": customerid
            ,"type":"Customer","transaction_id":payment_id,"payment_type":"Net Banking","amount": "\(amount)" ,"status":"1","created_date":resultString ,"created_by": customerCode
            ,"created_ip": getIPAddress() ]]
        
        api.fetchApiResult(viewController: self, paramDict: dict ){(result : OlinePaymentRootClass ,error) in
            if case .success = error {
                DispatchQueue.main.async {
                    
                    let result = result
                    let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                    alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVc, animated: true, completion: nil)
                    let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
                    let userCode = dict_UserInformation as? [String : AnyObject]
                    
                    if userCode != nil {
                        let  customerCode =  (userCode![UserDefaulKey.code]! as! String)
                        self.getUserInfo(customerid: customerCode)
                    }
                    self.setwalletView()
                    self.view.endEditing(true)
                    
                }
            } else if case .nodata = error{
                DispatchQueue.main.async {
                    //self.lblAlertText.text = "You are new user Please register to continue"
                }
            }
            else {
                DispatchQueue.main.async {
                    //self.lblAlertText.text = "You are new user Please register to continue"
                }}
        }
    }
    

    
    
    
    
    
    

    var appbgCollorYellow = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1)
    
    @IBOutlet weak var viewOtherWallet: UIView!
    @IBOutlet weak var lblWalletPoint: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtAmout: UITextField!
    @IBOutlet weak var btnAddcash: UIButton!
    @IBOutlet weak var btnAddCashOthers: UIButton!
    
    @IBOutlet weak var viewbgOtherWallet: UIView!
    @IBOutlet weak var viewTextbackground: UIView!
    
    
   
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtOthersAmount: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnGetUser: UIButton!
    @IBOutlet weak var btnAddOtherWallet: UIButton!
    var customerCode = String()
    var otherCustomer = String()
    var walletPaymentType = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        setDoneOnKeyboard()
        viewTextbackground.layer.borderColor = appbgCollorYellow.cgColor
        email = ""
        contactNumber = ""
        }
    func setwalletView(){
        viewTextbackground.transform = CGAffineTransform(scaleX: 0, y: 0)
        viewbgOtherWallet.transform = CGAffineTransform(scaleX: 0, y: 0)
        viewOtherWallet.transform = CGAffineTransform(scaleX: 0, y: 0)
        txtPhoneNumber.text = ""
        txtAmout.text = ""
        txtOthersAmount.text = ""
        lblUserName.text = ""
        lblUserName.textColor = .white
       
        btnAddCashOthers.backgroundColor = UIColor.white
        btnAddcash.backgroundColor = UIColor.white
        self.view.endEditing(true)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //
        setwalletView()
      let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            customerCode =  (userCode![UserDefaulKey.code]! as! String)
            
            
          getUserInfo(customerid: customerCode)
        }
           

    }
        
        
    func getUserInfo(customerid: String){
        self.view.endEditing(true)
        
        let api = APIRequestFetcher()
        
        let dictionary = ["MyProfile":["code": customerid]]
        api.fetchApiResult(viewController: self, paramDict: dictionary)
        { (result : UserInfoRootClass, error) in
           
            if case .success = error {
                DispatchQueue.main.async {
                    let result = result
                    self.setUserInfor(userinfo: result)
                    }
            } else if case .nodata = error {
                DispatchQueue.main.async {
                    //self.lblAlertText.text = "You are new user Please register to continue"
                }
            }
            else {
                DispatchQueue.main.async {
                    //self.lblAlertText.text = "You are new user Please register to continue"
                }
                
            }
        }
    }
    func setUserInfor(userinfo: UserInfoRootClass)  {
      customerCode = userinfo.CustomerInfo[0].code
      email = userinfo.CustomerInfo[0].email_address
      contactNumber = userinfo.CustomerInfo[0].contact
        let walletPoint = floatFromString(stringValue: userinfo.CustomerInfo[0].wallet_point ?? "0")
        lblWalletPoint.text = String(format: "\(RupeeSymbol)%.2f", walletPoint )
     // lblWalletPoint.text = "\(RupeeSymbol)\(userinfo.CustomerInfo[0].wallet_point!)"
    }
    @IBAction func didPressedGetDetails(_ sender: Any) {
        
        dismissKeyboard()
        
        
        if (txtPhoneNumber.text?.count == 0){
            let alertVc = UIAlertController(title: "", message: "Enter  Phonenumber", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
        else if !(txtPhoneNumber.text?.isValidContact)!{
            let alertVc = UIAlertController(title: "", message: "Enter Valid Phonenumber", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
            
        else{
            txtPhoneNumber.isUserInteractionEnabled = false
            getMentor(phonenumber: txtPhoneNumber.text!)
        }
        
        
        
    }
    
    @IBAction func didPressedAddCash(_ sender: UIButton) {
     
        viewbgOtherWallet.transform = CGAffineTransform(scaleX: 0, y: 0)
        viewOtherWallet.transform = CGAffineTransform(scaleX: 0, y: 0)
        btnAddCashOthers.backgroundColor = UIColor.white
        btnAddcash.backgroundColor = appbgCollorYellow
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.viewTextbackground.transform = CGAffineTransform.identity
        },
                       completion: { _ in

        })
    }
    
    @IBAction func didPressedAddOtherCash(_ sender: UIButton) {
        
        viewTextbackground.transform = CGAffineTransform(scaleX: 0, y: 0)
        btnAddCashOthers.backgroundColor = appbgCollorYellow
        btnAddcash.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.viewbgOtherWallet.transform = CGAffineTransform.identity
                       
        },
                       completion: { _ in
                        
        })
    }
    
    
    
    @IBAction func didPressedAddButton(_ sender: UIButton) {
        walletPaymentType = "\(sender.tag)"
        
        if txtAmout.text!.count > 0 || txtOthersAmount.text!.count > 0 {
            
            let rechargeAmount = walletPaymentType == "1" ? txtAmout.text : txtOthersAmount.text
            
           amount = intFromString(stringValue: rechargeAmount!)
            if amount > 0 {
               let amountInPaise = amount * Int(100.00);
                let options: [String:Any] = [
                    "amount" : amountInPaise as Any, //mandatory in paise
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
                //razorpay.open(options)
                // local = rzp_test_W57UXqJ4CJnQwc
              // live = rzp_live_RSo6ifr3caLLnh
                let razorpay: Razorpay!
                //razorpay = Razorpay.initWithKey("rzp_live_RSo6ifr3caLLnh", andDelegate: self)
                razorpay = Razorpay.initWithKey(RazorPayAppKey.liveKey.rawValue, andDelegate: self)
                razorpay.open(options, displayController: self)
                }else {
                let alertVc = UIAlertController(title: "", message: "Please enter valid amount..", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVc, animated: true, completion: nil)
            }

        }else {
            let alertVc = UIAlertController(title: "", message: "Please enter amount.", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
        
    
    }
    
 func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address!
    }
    @IBAction func didPressedMenuButton(_ sender: UIButton) {
        
            self.sideMenuController?.revealMenu()
        
    }
    
    func getMentor(phonenumber: String){
       
            startAnimating()
            
            
            let dictionary = ["GetMentor": ["mobile": phonenumber]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result:mentorRootClass, error)  in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            let resultUserinof = responsValue.Results[0]
                           
                            self.lblUserName.text = "\(resultUserinof.first_name ?? "") \(resultUserinof.last_name ?? "")"
                            UIView.animate(withDuration: 0.1,
                                           animations: {
                                            //self.viewbgOtherWallet.transform = CGAffineTransform.identity
                                           self.viewOtherWallet.transform = CGAffineTransform.identity
                            },
                                           completion: { _ in
                                            
                            })
                           self.otherCustomer = resultUserinof.code
                           
                        } else if responsValue.Response[0].response_code == "0"{
                            let msg = responsValue.Response[0].response_msg
                            
                            let alertVc = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
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
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
     
        
        
    }
}

extension WalletViewController : UITextFieldDelegate{
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        txtPhoneNumber.inputAccessoryView = keyboardToolbar
        txtAmout.inputAccessoryView = keyboardToolbar
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == txtPhoneNumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == txtAmout || textField == txtOthersAmount {
            let maxLength = 5
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}

public struct OlinePaymentRootClass: Decodable {
    
    public var Response : [OlinePaymentResponse]!
    
}
public struct OlinePaymentResponse: Decodable{
    
    public var response_code : String!
    public var response_msg : String!
    
}
