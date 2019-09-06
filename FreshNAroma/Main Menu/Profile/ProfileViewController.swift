//
//  ProfileViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 05/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//
import SkyFloatingLabelTextField
import UIKit
import TransitionButton

class ProfileViewController: RootViewController ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
    @IBOutlet weak var btnAddAddress: UIButton!{
        didSet{
            btnAddAddress.roundCorners(cornerRadius: 5)
        }
    }
     var pickerViewData = [PinCodeResult]()
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lblCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var lblState: SkyFloatingLabelTextField!
    @IBOutlet weak var lblPinCode: SkyFloatingLabelTextField!
    @IBOutlet weak var lblCity: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblAddressLine2: SkyFloatingLabelTextField!
    @IBOutlet weak var lblAddressLine1: SkyFloatingLabelTextField!
    @IBOutlet weak var lblEmailId: SkyFloatingLabelTextField!
    @IBOutlet weak var lblContactNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var lblLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var lblFirstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblDeliveryFirstName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblDeliveryEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var lblDeliveryContact: SkyFloatingLabelTextField!
    @IBOutlet weak var lblDeliveryLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var lblBillingCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var lblBillingState: SkyFloatingLabelTextField!
    @IBOutlet weak var lblBillingPinCode: SkyFloatingLabelTextField!
    @IBOutlet weak var lblBillingCity: SkyFloatingLabelTextField!
    @IBOutlet weak var lblBillingAddressLine2: SkyFloatingLabelTextField!
    @IBOutlet weak var lblBillingAddressLine1: SkyFloatingLabelTextField!
    // Shows now that it knows the type
    var skyTextFields: [SkyFloatingLabelTextField] = []
    var skyTextFieldEditable : [SkyFloatingLabelTextField] = []
    @objc  var viewPresentType = String()
    @IBOutlet weak var scrollView1: UIScrollView!
    var activeField: UITextField?
    var lastOffset: CGPoint!
    
    
    var userID : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.borderColor = UIColor.clear.cgColor
        view1.layer.borderWidth = 1
        view1.layer.cornerRadius = 4
        view2.layer.borderColor = UIColor.clear.cgColor
        view2.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.clear.cgColor
        view3.layer.borderWidth = 1
        view4.layer.borderColor = UIColor.clear.cgColor
        view4.layer.borderWidth = 1
        view2.layer.cornerRadius = 4
        view3.layer.cornerRadius = 4
        view4.layer.cornerRadius = 4
        
        
        
        registerForKeyboardNotifications()
        setDoneOnKeyboard()
        btnAddAddress.isHidden = true
        placeHolderText()
        nonEditTextField()
        
        
        
        if viewPresentType == "Present" {
            btnMenu.tag = 2001
            btnMenu .setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
            lblContactNumber.keyboardType = .numberPad
            btnAddAddress.setTitle("Save", for: .normal)
            
            
            btnAddAddress.isHidden = false
            lblNavigationTitle.text = " Profile"
            
        }else {
            lblNavigationTitle.text = " Profile"
            
            btnAddAddress.titleLabel?.text = "Save"
            btnAddAddress.setTitle("Save", for: .normal)
        }
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        lblPinCode.inputView = pickerView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        getDistricPincode()
        lblBillingState.text = STATE
        lblBillingCountry.text =  COUNTRY
        lblBillingCity.text = CITY
        
    }
    @objc func didTapView(gesture : UITapGestureRecognizer) {
        view.endEditing(true)
    }
        
    
    
    func nonEditTextField () {
        skyTextFields = [lblFirstName,lblLastName,lblEmailId,lblContactNumber,lblCity,lblState,lblCountry]
        for textField in skyTextFields {
            textField.delegate = self
            textField.isUserInteractionEnabled =  false
            textField.tintColor = overcastBlueColor
            textField.lineColor = lightGreyColor
            textField.selectedTitleColor = overcastBlueColor
            textField.selectedLineColor = overcastBlueColor
            textField.lineHeight = 1.0 // bottom line height in points
            textField.selectedLineHeight = 2.0
            textField.textColor = lightGreyColor
            
        }
    }
    fileprivate func getUserinformation() {
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            userID =  (userCode![UserDefaulKey.code]! as? String)!
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        getUserinformation()
        
        
        
    }
    
    func setDoneOnKeyboard() {
        
        
        let keyboardToolbar = UIToolbar()
        let keyboardToolbarpicker = UIToolbar()
        keyboardToolbarpicker.sizeToFit()
        keyboardToolbarpicker.backgroundColor = .lightGray
        keyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
       let textBarButton = UIBarButtonItem(title: "Delivery Available Pincode.", style: .plain, target: nil, action: nil)
        textBarButton.tintColor = .black
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbarpicker.items = [textBarButton,flexBarButton, doneBarButton]
        lblContactNumber.inputAccessoryView = keyboardToolbar
        lblBillingPinCode.inputAccessoryView = keyboardToolbar
        lblPinCode.inputAccessoryView = keyboardToolbarpicker
        lblPinCode.autocorrectionType = .no
        lblPinCode.spellCheckingType = .no
        lblPinCode.keyboardType = .phonePad
        lblContactNumber.keyboardType = .phonePad
       
        
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame!.origin.y
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func placeHolderText(){
        
        
        lblContactNumber.placeholder = "Phonenumber"
        lblFirstName.placeholder = "Firstname"
        lblLastName.placeholder = "Lastname"
        lblEmailId.placeholder = "Email Id"
        
        lblDeliveryContact.placeholder = "Phonenumber"
        lblDeliveryFirstName.placeholder = "Firstname"
        lblDeliveryLastName.placeholder = "Lastname"
        lblDeliveryEmail.placeholder = "Email Id"
        
        lblAddressLine1.placeholder = "Address 1"
        lblAddressLine2.placeholder = "Address 2"
        lblCity.placeholder = "City"
        lblState.placeholder = "State"
        lblCountry.placeholder = "Country"
        lblPinCode.placeholder = "Pincode"
        
        lblBillingAddressLine1.placeholder = "Address 1"
        lblBillingAddressLine2.placeholder = "Address 2"
        lblBillingCity.placeholder = "City"
        lblBillingState.placeholder = "State"
        lblBillingCountry.placeholder = "Country"
        lblBillingPinCode.placeholder = "Pincode"
        
        
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getUserInfo(customerid: String){
        self.view.endEditing(true)
        startAnimating()
        let api = APIRequestFetcher()
        api.delegate = self
        let dictionary = ["MyProfile":["code": customerid]]
        api.fetchApiResult(viewController: self, paramDict: dictionary)
        { (result : UserInfoRootClass, error) in
            
            
            DispatchQueue.main.async {
                self.stopAnimating()
                
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
        
        lblFirstName.text = userinfo.CustomerInfo[0].first_name
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
        lblBillingCity.text = userinfo.CustomerInfo[0].bill_city
        
        lblBillingState.text = userinfo.CustomerInfo[0].bill_state
        lblBillingCountry.text =  userinfo.CustomerInfo[0].bill_country
        lblBillingPinCode.text = userinfo.CustomerInfo[0].bill_pin_code
        
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
    
    func setUserBillingAddress(isSet: Bool){
        lblBillingAddressLine1.text = isSet ? lblAddressLine1.text : ""
        lblBillingAddressLine2.text = isSet ? lblAddressLine2.text : ""
        lblBillingCity.text = isSet ? lblCity.text : ""
        lblBillingState.text = isSet ? lblState.text : ""
        lblBillingCountry.text = isSet ? lblCountry.text : ""
      //  lblBillingPinCode.text = isSet ? lblPinCode.text : ""
        lblDeliveryFirstName.text = isSet ? lblFirstName.text : ""
        lblDeliveryLastName.text = isSet ? lblLastName.text : ""
        lblDeliveryContact.text = isSet ? lblContactNumber.text : ""
        lblDeliveryEmail.text = isSet ? lblEmailId.text : ""
    }
    @IBAction func didPressedCheckBox(_ sender: UIButton) {
        
        if sender.backgroundImage(for: .normal) == UIImage(named: "uncheckBox") {
            sender.setBackgroundImage(UIImage(named: "checkBox"), for: .normal)
            setUserBillingAddress(isSet: true)
        } else {
            sender.setBackgroundImage(UIImage(named: "uncheckBox"), for: .normal)
            setUserBillingAddress(isSet: false)
            
            
        }
    }
    
}


extension ProfileViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location == 0 && string == " ") {
            return false;
        }
        
        if textField == lblContactNumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == lblPinCode || textField == lblBillingPinCode {
            if string == ""{
                return true
            }else if textField.text!.count + string.count > 6 {
                return false
            }else {
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
            
        }
        return true
    }
    
    func userDate() -> [String : String]{
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        let code_id =  (userCode![UserDefaulKey.code]! as? String)!
        
        
        
        let userProfileData =
            ["code" : code_id,
             "first_name": lblFirstName.text!,
             "last_name": lblLastName.text!,
             "contact" : lblContactNumber.text!,
             "email_address" : lblEmailId.text!,
             
             "country" : lblCountry.text!,
             "state" : lblState.text!,
             "city" : lblCity.text!,
             "shipping_address": lblAddressLine1.text!,
             "shipping_address2": lblAddressLine2.text!,
             "pin_code": lblPinCode.text!,
             
             "bill_pin_code": lblBillingPinCode.text!,
             "bill_address": lblBillingAddressLine1.text!,
             "bill_address2": lblBillingAddressLine2.text!,
             "bill_country" : lblBillingCountry.text!,
             "bill_state" : lblBillingState.text!,
             "bill_city": lblBillingCity.text!,
//             "bill_first_name" : lblDeliveryFirstName.text!,
//             "bill_last_name" : lblDeliveryLastName.text!,
//             "bill_contact" : lblDeliveryContact.text!,
//             "bill_email_address" : lblDeliveryEmail.text!
                             "bill_first_name" : lblFirstName.text!,
                             "bill_last_name" : lblLastName.text!,
                             "bill_contact" : lblContactNumber.text!,
                             "bill_email_address" : lblEmailId.text!

                ] as [String : String]
        
        
        return userProfileData
    }
    
    func showAlertFroValidation(validationText : String){
        let alertVc = UIAlertController(title: "", message:validationText, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler:nil ))
        self.present(alertVc, animated: true, completion: nil)
        
    }
    func trimTextfield(text : String) -> String{
        let trimeString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimeString
    }
    func textFieldValidation() -> Bool{
        
//        if (trimTextfield(text:lblFirstName.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Firstname")
//            return false
//        } else if (trimTextfield(text:lblLastName.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Lastname")
//            return false
//        } else if (trimTextfield(text:lblContactNumber.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Phonenumber")
//            return false
//        }else if (trimTextfield(text:lblEmailId.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Email id")
//            return false
//        }
//        if (trimTextfield(text:lblDeliveryFirstName.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Delivery Firstname")
//            return false
//        } else if (trimTextfield(text:lblDeliveryLastName.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Delivery Lastname")
//            return false
//        } else if (trimTextfield(text:lblDeliveryContact.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Delivery Phonenumber")
//            return false
//        }else if (trimTextfield(text:lblDeliveryEmail.text!).isEmpty){
//            showAlertFroValidation(validationText: "Enter Delivery Email id")
//            return false
//        }
        
        if  (lblBillingAddressLine1.text?.isEmpty)!  {
            showAlertFroValidation(validationText: "Enter Billing Address1")
            return false
        }
        else if (lblBillingAddressLine2.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Billing Address2")
            return false
        }
        else if (lblBillingCity.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Billing City")
            return false
        }
        else if (lblBillingState.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Billing State")
            return false
        }
        else if (lblBillingCountry.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Billing country")
            return false
        }
        else if (lblBillingPinCode.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Billing Pincode")
            return false
        }
        else if ((lblBillingPinCode.text?.count)! < 6)  {
            showAlertFroValidation(validationText: "Enter valid Billing Pincode")
            return false
        } else if   (trimTextfield(text:lblAddressLine1.text!).isEmpty) {
            showAlertFroValidation(validationText: "Enter Delivery Address1")
            return false
        }
        else if (lblAddressLine2.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Delivery Address2")
            return false
        }
        else if (lblCity.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Delivery City")
            return false
        }
        else if (lblState.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Delivery State")
            return false
        }
        else if (lblCountry.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Delivery country")
            return false
        }
        else if (lblPinCode.text?.isEmpty)! {
            showAlertFroValidation(validationText: "Enter Delivery Pincode")
            return false
        }
        else if ((lblPinCode.text?.count)! < 6 )  {
            showAlertFroValidation(validationText: "Enter valid Delivery Pincode")
            return false
        }
        
        
        
        return true
    }
    
    
    @IBAction func didPressedSavebutton(_ sender: UIButton) {
        if textFieldValidation(){
            if sender.currentTitle == "Save"{
                for textField in skyTextFields {
                    textField.textColor = lightGreyColor
                    
                    btnAddAddress.isHidden = true
                    updateUserInfo()
                }
            }else {
                updateUserInfo()
                
                
                //  didPressedCloseButton(sender)
            }
        }
        
    }
    func updateUserInfo(){
        startAnimating()
        api.updateUserProfile(userinfo: userDate() , viewController: self) { (result, error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.stopAnimating()
            }
            
    if case .success = error {
                
                DispatchQueue.main.async {
                    let responsValue = result["result"] as! UserprofileUpdateRootClass
                    
                    if responsValue.Response[0].response_code == "1"{
                        let response_msg = responsValue.Response[0].response_msg
                       
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateProfile"), object: nil, userInfo: nil)
                        let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                    //}
                    
                    
                }
            } else {
               
                let alertVc = UIAlertController(title: "", message:("Error" ), preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertVc, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    @IBAction func didPressedEditbutton(_ sender: UIButton) {
        
        
        btnAddAddress.isHidden = false
        
        
        
    }
    
    
    func getDistricPincode() {
        
            startAnimating()
             let dictionary = ["Pincodes":["city" : "Coimbatore"]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : PinCodeRootClass, error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            self.pickerViewData = responsValue.Results
                            
                           } else if responsValue.Response[0].response_code == "0"{
                            let msg = responsValue.Response[0].response_msg
                            
                            let alertVc = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
                        }
                    }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
                       
                        
                        let alertVc = UIAlertController(title: "", message: result.Response![0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: result.Response![0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
        
        
        
    }
    
}
    



extension ProfileViewController {
    func registerForKeyboardNotifications()
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    
    @objc func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        //scrollView1.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        scrollView1.contentInset = contentInsets
        scrollView1.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if  (activeField != nil)
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView1.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        //        let info : NSDictionary = notification.userInfo! as NSDictionary
        //        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        //        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        //        self.scrollView1.contentInset = contentInsets
        //        self.scrollView1.scrollIndicatorInsets = contentInsets
        //        self.view.endEditing(true)
        //self.scrollView1.isScrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        activeField = nil
    }
    
    
    @IBAction func didPressedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileViewController : UIPickerViewDataSource, UIPickerViewDelegate {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row].pincode
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lblPinCode.text = pickerViewData[row].pincode
       // lblBillingCity.text = pickerViewData[row].city
        
    }
    

}





public struct UserprofileUpdateRootClass : Decodable {
    
    public var Response : [UserprofileUpdateResponse]!
    
}
public struct UserprofileUpdateResponse : Decodable{
    
    public var response_code : String!
    public var response_msg : String!
    
}




//MARK: PinCode
public struct PinCodeRootClass : Decodable {
    
    public var Response : [PinCodeResponse]!
    public var Results : [PinCodeResult]!
    
}
public struct PinCodeResult : Decodable {
    
    public var area : String!
    public var city : String!
    public var deleted_status : String!
    public var id : String!
    public var pincode : String!
    
}
public struct PinCodeResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}

