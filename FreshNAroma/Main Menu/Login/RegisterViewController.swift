//
//  RegisterViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 20/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import RSFloatInputView
import SkyFloatingLabelTextField
import NVActivityIndicatorView
class RegisterViewController: UIViewController , NVActivityIndicatorViewable ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var  phoneNumber = String()
    
    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtLastname: SkyFloatingLabelTextField!{
        didSet{ txtLastname.delegate = self }
    }
    @IBOutlet weak var txtReferralCode: SkyFloatingLabelTextField!{
        didSet{ txtReferralCode.delegate = self }
    }
    @IBOutlet weak var txtFirstname: SkyFloatingLabelTextField!
    {
        didSet{ txtFirstname.delegate = self}
    }
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    {
        didSet{ txtEmail.delegate = self }
    }
    @IBOutlet weak var txtPhone: SkyFloatingLabelTextField!
        {
        didSet{ txtPhone.delegate = self }
    }
    var Otp = String ()
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var lblOtp: UILabel!
    var viewType = String()
    @IBOutlet weak var viewHightConstraint: NSLayoutConstraint!
    var otpSting = String()
     var textFields: [SkyFloatingLabelTextField] = []
    @IBOutlet  var loginView: UIView!
    @IBOutlet  weak var txtPassword1: UITextField!{
        didSet{
            txtPassword1.delegate = self
            txtPassword1.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtPassword2: UITextField!{
        didSet{
            txtPassword2.delegate = self
            txtPassword2.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtPassword3: UITextField!{
        didSet{
            txtPassword3.delegate = self
            txtPassword3.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtPassword4: UITextField!{
        didSet{
            txtPassword4.delegate = self
            txtPassword4.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var contentHeightConstraint1: NSLayoutConstraint!
    @IBOutlet weak var scrollView1: UIScrollView!
    let api = APIRequestFetcher()
   
   //    MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDoneOnKeyboard()
        api.delegate = self

        
        txtPassword1.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged)
        txtPassword2.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged )
        txtPassword3.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged )
        txtPassword4.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged )
        
        
        textFieldDesign()
        showOTPView(show: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    @objc func didTapView(gesture : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    

    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if textField.text?.utf16.count == 1  {
            switch textField {
            case txtPassword1:
                txtPassword2.becomeFirstResponder()
            case txtPassword2:
                txtPassword3.becomeFirstResponder()
            case txtPassword3:
                txtPassword4.becomeFirstResponder()
            case txtPassword4:
                txtPassword4.resignFirstResponder()
            default:
                break
            }
        }
        else if textField.text == ""{
            switch textField {
          
            case txtPassword2:
                txtPassword1.becomeFirstResponder()
            case txtPassword3:
                txtPassword2.becomeFirstResponder()
            case txtPassword4:
                txtPassword3.becomeFirstResponder()
            default:
                break
            }
        }
    }
    func placeholer(){
        txtEmail.placeholder = "Email"
        txtFirstname.placeholder = "First name"
        txtLastname.placeholder = "Last name"
        txtPhone.placeholder = "Phone number"
        txtReferralCode.placeholder = "Referral Code (optional)"
        
        let referalCode = UserDefaults.standard.string(forKey: "referralCode")
        if let string = referalCode, !string.isEmpty {
            txtReferralCode.text = referalCode
          
        }else {
            
        }
       
    }
    
    func textFieldDesign(){
       let lightGreyColor = UIColor.hexStringToUIColor(hex: ColorCode.gray.rawValue, alphavalue: 1.0)
       placeholer()
        txtEmail.textColor = lightGreyColor
        txtEmail.lineColor = UIColor.hexStringToUIColor(hex:ColorCode.gray95.rawValue, alphavalue: 1.0)
        txtEmail.selectedTitleColor = appThemColor
        txtEmail.selectedLineColor = appThemColor
       
        txtEmail.tintColor = appThemColor
        txtFirstname.textColor = UIColor.hexStringToUIColor(hex: ColorCode.gray.rawValue, alphavalue: 1.0)
        txtFirstname.lineColor = UIColor.hexStringToUIColor(hex:ColorCode.gray95.rawValue, alphavalue: 1.0)
        txtFirstname.selectedTitleColor = appThemColor
        txtFirstname.selectedLineColor = appThemColor
        txtFirstname.tintColor = appThemColor
        
        
        
        txtLastname.textColor = UIColor.hexStringToUIColor(hex: ColorCode.gray.rawValue, alphavalue: 1.0)
        txtLastname.lineColor = UIColor.hexStringToUIColor(hex:ColorCode.gray95.rawValue, alphavalue: 1.0)
        txtLastname.selectedTitleColor = appThemColor
        txtLastname.selectedLineColor = appThemColor
        txtLastname.tintColor = appThemColor
        
        txtReferralCode.textColor = UIColor.hexStringToUIColor(hex: ColorCode.gray.rawValue, alphavalue: 1.0)
        txtReferralCode.lineColor = UIColor.hexStringToUIColor(hex:ColorCode.gray95.rawValue, alphavalue: 1.0)
        txtReferralCode.selectedTitleColor = appThemColor
        txtReferralCode.selectedLineColor = appThemColor
        txtReferralCode.tintColor = appThemColor
        
        
        txtPhone.textColor = UIColor.hexStringToUIColor(hex: ColorCode.gray.rawValue, alphavalue: 1.0)
        txtPhone.lineColor = UIColor.hexStringToUIColor(hex:ColorCode.gray95.rawValue, alphavalue: 1.0)
        txtPhone.selectedTitleColor = appThemColor
        txtPhone.selectedLineColor = appThemColor
        txtPhone.tintColor = appThemColor
        

    
        textFields  = [txtPhone, txtEmail, txtLastname, txtFirstname,txtReferralCode]

    }
    
    
    
    
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
   
    
    
   

    func showingTitleInAnimationComplete(_ completed: Bool) {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.showingTitleInProgress = false
            self.textFieldDesign()
            if !self.isSubmitButtonPressed {
                self.hideTitleVisibleFromFields()
            }
        }
    }
    
    func showingerrorTitleInAnimationComplete(_ completed: Bool) {
        // If a field is not filled out, display the highlighted title for 0.3 seco
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.showingTitleInProgress = false
            self.textFieldDesign()
            if !self.isSubmitButtonPressed {
                self.hideTitleVisibleFromFields()
            }
        }
    }
    
    var isSubmitButtonPressed: Bool = false
    
    var showingTitleInProgress: Bool = false
    func hideTitleVisibleFromFields() {
        
        for textField in textFields {
            textField.setTitleVisible(false, animated: true)
            textField.isHighlighted = false
        }
    }
    
    
    
    
    
    @IBAction func didPressedCreateAccount(_ sender: UIButton) {
        
        if sender.currentTitle != "Submit" {
            
        for textField in textFields where !textField.hasText {
            showingTitleInProgress = true
            textField.setTitleVisible(
                true,
                animated: true,
                animationCompletion: showingTitleInAnimationComplete
                
            )
            textField.isHighlighted = true
        }
        
        if (txtPhone.text?.count)! > 0  && !(txtPhone.text?.isValidContact)! {
        
            txtPhone.placeholder = "Enter valide Phonenumber"
            txtPhone.selectedTitleColor = .red
            showingTitleInProgress = true
            txtPhone.setTitleVisible(
                true,
                animated: true,
                animationCompletion: showingerrorTitleInAnimationComplete
                
            )
            txtPhone.isHighlighted = true
            
        }
        
        else if (txtEmail.text?.count)! > 0  && !(txtEmail.text?.isValidEmail)! {
            
          
            txtEmail.placeholder = "Enter valide Email"
            showingTitleInProgress = true
            txtEmail.selectedTitleColor = .red
            txtEmail.setTitleVisible(
                true,
                animated: true,
                animationCompletion: showingerrorTitleInAnimationComplete
                )
            txtEmail.isHighlighted = true
            
            
        }
      else if ((txtPhone.text?.count)! > 0 && (txtFirstname.text?.count)! > 0 && (txtLastname.text?.count)! > 0 && (txtEmail.text?.count)! > 0){
            startAnimating()
            let dictionary = ["RegisterOTP":["mobile":txtPhone.text!]]
            api.fetchApiResult(viewController: self, paramDict: dictionary){
                (result : registerOtpRootClass,error) in
                                let responsValue = result
                DispatchQueue.main.async {
                    self.stopAnimating()

                if responsValue.Response[0].response_code == "1" {
                    self.Otp = responsValue.Response[0].response_otp
                    let alertVc = UIAlertController(title: "", message:"OTP has been sent on your mobile no", preferredStyle: .alert)
                                         alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                          self.present(alertVc, animated: true, completion: nil)
                    self.btnCreateAccount.setTitle("Submit", for: .normal)
                self.showOTPView(show: true)
                }else if responsValue.Response[0].response_code == "0"  {
            
                     let response_msg = responsValue.Response[0].response_msg
                     
                     let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                     alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                     self.dismiss(animated: true, completion: nil)
                     }))
                     self.present(alertVc, animated: true, completion: nil)

        
}
        
        }
            }
  
        }
        }else{
            let otp = "\(txtPassword1.text ?? "")\(txtPassword2.text ?? "")\(txtPassword3.text ?? "")\(txtPassword4.text ?? "")"
            let trimmedotp = otp.trimmingCharacters(in: .whitespaces)
            if trimmedotp.count != 4 && trimmedotp.count > 0 || (Otp != trimmedotp){
                let alertVc = UIAlertController(title: "", message: "Enter Valid OTP", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVc, animated: true, completion: nil)
            }
                
            else{
                
                var userInfo = [String : String]()
                userInfo["first_name"] = self.txtFirstname.text
                userInfo["last_name"] = self.txtLastname.text
                userInfo["contact"]  = self.txtPhone.text
                userInfo["email_address"] = self.txtEmail.text
                userInfo["otp"] = trimmedotp
                userInfo["ref_level1"] = self.txtReferralCode.text
               
                
                otpSting = trimmedotp
                self.startAnimating()
                
                
                
                
                self.api.userRegistration(userinfo: userInfo, viewController: self) { (result, error) in
                    DispatchQueue.main.async {
                        self.stopAnimating()
                    }
                    // let responsValue = result["result"] as! otpRootClass
                    
                    if case .success = error {
                        let responsValue = result["result"] as! otpRootClass
                        
                        if responsValue.Response[0].response_code == "1" {
                            UserDefaults.standard.removeObject(forKey: "referralCode")
                            
                        }else if responsValue.Response[0].response_code == "0" {
                            
                        }
                        
                        let response_msg = responsValue.Response[0].response_msg
                        DispatchQueue.main.async {

                            
                            let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                                self .getotp(otp:self.otpSting )
                            }))
                            self.present(alertVc, animated: true, completion: nil)
                            
                            
                            
                            
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
        }
        
    }
    
    func getotp(otp: String){
        
            startAnimating()
            
            let dictionary = ["Login": ["mobile": txtPhone.text!,"otp":otp]]
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : otpRootClass, error) in
           
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "0"{
                            let response_msg = responsValue.Response[0].response_msg
                            let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                
                                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
                                self.present(nextViewControler!, animated: true)
                            }))
                            self.present(alertVc, animated: true, completion: nil)
                            
                        }
                        else if responsValue.Response[0].response_code == "1"{
                           // self.dismiss(animated: true, completion: nil)
                            // UserDefaults.standard.removeObject(forKey: UserDefaulKey.userData)
                            let userData1 = responsValue.Data![0]
                            
                            user_code = userData1.code!
                            user_first_name = userData1.first_name
                            user_last_name = userData1.last_name
                            user_contact = userData1.contact
                            user_email_address = userData1.email_address
                            user_contact = userData1.contact
                            user_state = userData1.state
                            user_city =  userData1.city
                            user_pin_code = userData1.pin_code
                            user_shipping_address = userData1.shipping_address
                            user_shipping_address2 = userData1.shipping_address2
                            user_bill_address = userData1.bill_address
                            user_shipping_address2 =  userData1.bill_address2
                            user_bill_city = userData1.bill_city
                            user_bill_state = userData1.bill_state
                            user_bill_country = userData1.bill_country
                            user_pin_code = userData1.bill_pin_code
                            let key = UserInformationDefaultKey()
                            let userData = [key.code : user_code, key.first_name : user_first_name,key.last_name : user_last_name,key.contact: user_contact,key.email_address : user_email_address,key.shipping_address : user_shipping_address,
                                            key.shipping_address2 : user_shipping_address2,key.city : user_city,
                                            key.state : user_state,key.country : user_country, key.pin_code : user_pin_code,key.bill_address: user_bill_address,key.bill_address2 : user_bill_address2,key.bill_city : user_bill_city,key.bill_state : user_bill_state,key.bill_country : user_bill_country,key.bill_pin_code : user_bill_pin_code]
                            
                            UserDefaults.standard.set(userData, forKey: UserDefaulKey.userdict)
                            
                            
                           self.dismiss(animated: true, completion: nil)
                            setUserDefautValeu(loginId: userData1.code!, address: userData1.bill_address!)
                            
                        }
                        else if responsValue.Response[0].response_code == "2"{
                            
                            let response_msg = responsValue.Response[0].response_msg
                            let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
                        }
                        else if responsValue.Response[0].response_code == "3"{
                            let response_msg = responsValue.Response[0].response_msg
                            
                            let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
                            self.showOTPView(show: true)
                        }
                        
                        
                    }
                } else if case .nodata = error{
                    DispatchQueue.main.async {
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
    
    
    @IBAction func didPressedCheckBox(_ sender: UIButton) {
        
      if sender.backgroundImage(for: .normal) == UIImage(named: "uncheckBox") {
            sender.setBackgroundImage(UIImage(named: "checkBox"), for: .normal)
      } else {
        sender.setBackgroundImage(UIImage(named: "uncheckBox"), for: .normal)
        
            
       }
    }
    
   
}
extension RegisterViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == txtPhone {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else if textField == txtPassword1 || textField == txtPassword2 || textField == txtPassword3 || textField == txtPassword4 {
           
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string == numberFiltered {
                let currentText = textField.text ?? ""
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                return updatedText.count <= 1
            }else{
                return false
            }
        }
       return true
    }
    func setDoneOnKeyboard() {
       
       
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        txtPhone.inputAccessoryView = keyboardToolbar
        txtPhone.keyboardType = .phonePad
        txtEmail.keyboardType = .emailAddress
        txtPassword1.inputAccessoryView = keyboardToolbar
        txtPassword2.inputAccessoryView = keyboardToolbar
        txtPassword3.inputAccessoryView = keyboardToolbar
        txtPassword4.inputAccessoryView = keyboardToolbar
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension RegisterViewController {
    func addObservers()
    {
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (notifiction) in
            self.keyboardWillHide(notification: notifiction)
        }
    }
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView1.contentInset = contentInset
    }
    func keyboardWillHide(notification: Notification){
        scrollView1.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @IBAction func didPressedCloseButton(_ sender: Any) {
       if viewType == ViewControllerDisplayType.closeView.rawValue{
        dismiss(animated: true, completion: nil)}
       else {
        navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: OTPView
    func showOTPView(show : Bool){

        //btnCreateAccount.setTitle("Submit", for: .normal)
        viewOtp.isHidden = show ? false : true
        lblOtp.isHidden = show ? false : true
        btnResend.isHidden = show ? false : true
        viewHightConstraint.constant = show ? 100 : 0
        self.updateViewConstraints()
        
        
    }
}
public struct registerOtpRootClass : Decodable {
    
    public var Response : [registerOtpResponse]!
    
}
public struct registerOtpResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    public var response_otp : String!
    
}
