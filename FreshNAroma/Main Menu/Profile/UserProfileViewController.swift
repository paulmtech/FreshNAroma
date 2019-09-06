//
//  UserProfileViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 09/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class UserProfileViewController: RootViewController ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var viewDelieryAddress: UIView!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblBillingAddress: UILabel!
    @IBOutlet weak var viewBllingAddress: UIView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblWalletPoint: UILabel!
    @IBOutlet weak var viewWallet: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhonenumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    var code : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewDesign(view: viewWallet)
        self.viewDesign(view: viewBllingAddress)
        self.viewDesign(view: viewDelieryAddress)
        self.viewDesign(view: btnEditProfile)
        api.delegate = self
        // Do any additional setup after loading the view.
    }
    func viewDesign(view: UIView)  {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: NSNotification.Name(rawValue: "updateProfile"), object: nil)
        
    }
    @objc func onDidReceiveData(_ notification:Notification) {
       getUserProfile()
    }
    fileprivate func getUserProfile() {
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            code =  (userCode![UserDefaulKey.code]! as? String)!
            
            if code.count == 0 {
                // let response_msg = responsValue.Response[0].response_msg
                let alertVc = UIAlertController(title: "", message: "New user! Kindly Register", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                   
                    let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
                    self.present(nextViewControler!, animated: true)
                }))
                self.present(alertVc, animated: true, completion: nil)
            }else{
                getUserInfo(customerid: code)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        getUserProfile()
        
        
        
    }
    func getUserInfo(customerid: String){
        self.view.endEditing(true)
        startAnimating()
        // self.view.isUserInteractionEnabled = false
        let api = APIRequestFetcher()
        
        let dictionary = ["MyProfile":["code": customerid]]
        api.fetchApiResult(viewController: self, paramDict: dictionary)
        { (result : UserInfoRootClass, error) in
            
            
            DispatchQueue.main.async {
                self.stopAnimating()
                // self.view.isUserInteractionEnabled = true
            }
            if case .success = error {
                DispatchQueue.main.async {
                    let result = result
                    
                    self.setUserInfor(userinfo: result)
                    // self.lblAlertText.text = "You are our valuable customer"
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
    func setUserInfor(userinfo: UserInfoRootClass)  {
        
        
        lblName.text = "\(userinfo.CustomerInfo[0].first_name ?? "") \(userinfo.CustomerInfo[0].last_name ?? "")"
        lblPhonenumber.text = userinfo.CustomerInfo[0].contact
        lblEmail.text = userinfo.CustomerInfo[0].email_address
        
        let billingAddress1 = userinfo.CustomerInfo[0].bill_address.count > 0 ? "\(userinfo.CustomerInfo[0].bill_address!)," : ""
        let billingAddress2 = userinfo.CustomerInfo[0].bill_address2.count > 0 ? "\(userinfo.CustomerInfo[0].bill_address2!)," : ""
        let billingcity = userinfo.CustomerInfo[0].bill_city.count > 0 ? "\(userinfo.CustomerInfo[0].bill_city!)," : ""
        let billingstate = userinfo.CustomerInfo[0].bill_state.count > 0 ? "\(userinfo.CustomerInfo[0].bill_state!)," : ""
        let billingcountry = userinfo.CustomerInfo[0].bill_country.count > 0 ? "\(userinfo.CustomerInfo[0].bill_country!)," : ""
        let billingpincode = userinfo.CustomerInfo[0].bill_pin_code.count > 0 ? "\(userinfo.CustomerInfo[0].bill_pin_code!)" : ""
        
        lblBillingAddress.text = "\(billingAddress1) \(billingAddress2)\(billingcity)\(billingstate)\(billingcountry)\(billingpincode)"
        
        let shippingAddress1 = userinfo.CustomerInfo[0].shipping_address.count > 0 ? "\(userinfo.CustomerInfo[0].shipping_address!)," : ""
        let shippingAddress2 = userinfo.CustomerInfo[0].shipping_address2.count > 0 ? "\(userinfo.CustomerInfo[0].bill_address2!)," : ""
        let shippingcity = userinfo.CustomerInfo[0].city.count > 0 ? "\(userinfo.CustomerInfo[0].city!)," : ""
        let shippingstate = userinfo.CustomerInfo[0].state.count > 0 ? "\(userinfo.CustomerInfo[0].state!)," : ""
        let shippingcountry = userinfo.CustomerInfo[0].country.count > 0 ? "\(userinfo.CustomerInfo[0].country!)," : ""
        let shippingpincode = userinfo.CustomerInfo[0].pin_code.count > 0 ? "\(userinfo.CustomerInfo[0].pin_code!)" : ""
        
        lblDeliveryAddress.text = "\(shippingAddress1) \(shippingAddress2)\(shippingcity)\(shippingstate)\(shippingcountry)\(shippingpincode)"
        let walletPoint = floatFromString(stringValue: userinfo.CustomerInfo[0].wallet_point ?? "0")
        lblWalletPoint.text = String(format: "\(RupeeSymbol)%.2f", walletPoint )
       // lblWalletPoint.text = "\(RupeeSymbol)\(userinfo.CustomerInfo[0].wallet_point ?? "0")"
     /*   lblFirstName.text = userinfo.CustomerInfo[0].first_name
        lblLastName.text = userinfo.CustomerInfo[0].last_name
        lblEmailId.text = userinfo.CustomerInfo[0].email_address
        lblAddressLine1.text = userinfo.CustomerInfo[0].shipping_address
        lblAddressLine2.text = userinfo.CustomerInfo[0].shipping_address2
        lblContactNumber.text = userinfo.CustomerInfo[0].contact
        
        lblDeliveryFirstName.text = userinfo.CustomerInfo[0].bill_first_name
        lblDeliveryLastName.text = userinfo.CustomerInfo[0].bill_last_name
        lblDeliveryContact.text = userinfo.CustomerInfo[0].bill_contact
        lblDeliveryEmail.text = userinfo.CustomerInfo[0].bill_email_address
        
        lblCity.text = CITY//userinfo.CustomerInfo[0].city
        lblState.text = STATE //userinfo.CustomerInfo[0].state
        lblCountry.text = COUNTRY//userinfo.CustomerInfo[0].country
        lblPinCode.text = userinfo.CustomerInfo[0].pin_code
        
        lblBillingAddressLine1.text = userinfo.CustomerInfo[0].bill_address
        lblBillingAddressLine2.text = userinfo.CustomerInfo[0].bill_address2
        lblBillingCity.text = CITY//userinfo.CustomerInfo[0].bill_city
        
        lblBillingState.text = STATE//userinfo.CustomerInfo[0].bill_state
        lblBillingCountry.text =  COUNTRY//userinfo.CustomerInfo[0].bill_country
        lblBillingPinCode.text = userinfo.CustomerInfo[0].bill_pin_code
   */
        let key = UserInformationDefaultKey()
        let userData = [key.code : userinfo.CustomerInfo[0].code,
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didPressedEditButton(_ sender: Any) {
       
        let storyBoardId =  "UpdateProfile"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! ProfileViewController
        nextViewControler.viewPresentType = "Present"
        self.present(nextViewControler, animated: true, completion: nil)
        
}
}
