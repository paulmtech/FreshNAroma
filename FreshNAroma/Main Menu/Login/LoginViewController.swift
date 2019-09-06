//
//  LoginViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 19/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NVActivityIndicatorView
var api = APIRequestFetcher()

class LoginViewController: UIViewController,NVActivityIndicatorViewable ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
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
    @IBOutlet weak var txtPhonenumber: SkyFloatingLabelTextField!{
didSet{
    txtPhonenumber.delegate = self
    txtPhonenumber.keyboardType = .numberPad
    
}
}
        
    
    @IBOutlet weak var btnLogin: UIButton!{
    didSet {
        btnLogin.roundCorners(cornerRadius: 5)
    }
}
    @IBOutlet weak var btnRegister: UIButton!{
        didSet{ btnRegister.roundCorners(cornerRadius: 5)
    }
    }
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var lblOtp: UILabel!
    @IBOutlet weak var viewHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    func showOTPView(show : Bool){
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
      
        txtPhonenumber.placeholder = "Phonenumber"
        txtPhonenumber.textColor = darkGreyColor
        txtPhonenumber.lineColor = lightGreyColor
        txtPhonenumber.selectedTitleColor = lightGreyColor
        txtPhonenumber.selectedLineColor = appThemColor
        txtPhonenumber.tintColor = appThemColor
        txtPhonenumber.lineHeight = 1.0
        txtPhonenumber.selectedLineHeight = 2.0
        viewOtp.isHidden = show ? false : true
        lblOtp.isHidden = show ? false : true
        btnResend.isHidden = show ? false : true
        viewHightConstraint.constant = show ? 100 : 0
        self.updateViewConstraints()
       
        
    }
    // MARK: - ViewControllerDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        setDoneOnKeyboard()
        txtPassword1.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged)
        txtPassword2.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged )
        txtPassword3.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged )
        txtPassword4.addTarget(self, action:#selector(textFieldDidChanged(_:)), for: .editingChanged )
        
        api.delegate = self
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
    
    
    
   
    @IBAction func showRegisterView(_ sender: Any) {
      
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        nextViewControler?.viewType = ViewControllerDisplayType.closeView.rawValue
        self.navigationController?.pushViewController(nextViewControler!, animated: true)
        

    }
    @IBAction func didPressedCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didPressedLogin(_ sender: Any) {
        dismissKeyboard()
        let otp = "\(txtPassword1.text ?? "")\(txtPassword2.text ?? "")\(txtPassword3.text ?? "")\(txtPassword4.text ?? "")"
        let trimmedotp = otp.trimmingCharacters(in: .whitespaces)
        if (txtPhonenumber.text?.count == 0){
            let alertVc = UIAlertController(title: "", message: "Enter  Phonenumber", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
       else if !(txtPhonenumber.text?.isValidContact)!{
            let alertVc = UIAlertController(title: "", message: "Enter Valid Phonenumber", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        } else if trimmedotp.count != 4 && trimmedotp.count > 0{
            let alertVc = UIAlertController(title: "", message: "Enter Valid OTP", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
        
        else{
            
            getotp(otp: trimmedotp)
        }
    
    }
    
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
        scrollView.contentInset = contentInset
    }
    func keyboardWillHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
func getotp(otp: String){
    
            startAnimating()
            let dictionary = ["Login": ["mobile": txtPhonenumber.text!,"otp":otp]]
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : otpRootClass, error) in
                DispatchQueue.main.async {
                    self.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "0"{
                            let response_msg = responsValue.Response[0].response_msg
                            let alertVc = UIAlertController(title: "", message:response_msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                               
                                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
                                nextViewControler?.viewType = ViewControllerDisplayType.closeView.rawValue
                                self.navigationController?.pushViewController(nextViewControler!, animated: true)
                            }))
                            self.present(alertVc, animated: true, completion: nil)
                            
                        }else if responsValue.Response[0].response_code == "1"{
                           
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
                            
                            
                            
                            setUserDefautValeu(loginId: userData1.code!, address: userData1.bill_address!)
                            
                          
                            let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "SideMenu")
                            self.navigationController?.pushViewController(nextViewControler, animated: true)
                            
                            
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
                       
                        let alertVc = UIAlertController(title: "", message: result.Response[0].response_code, preferredStyle: .alert)
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


// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPhonenumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else {
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
        
        
        
       // return true
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
   func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        txtPhonenumber.inputAccessoryView = keyboardToolbar
        txtPassword1.inputAccessoryView = keyboardToolbar
        txtPassword2.inputAccessoryView = keyboardToolbar
        txtPassword3.inputAccessoryView = keyboardToolbar
        txtPassword4.inputAccessoryView = keyboardToolbar
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
 
    
   
}







// Otp
public struct otpRootClass : Decodable {
    
    public var Data : [otpData]!
    public var Notificationcount : Int!
    public var Response : [otpResponse]!
    
}
public struct otpResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct otpData: Decodable {
    
   public var id: String!
   public var code:  String!
   public var first_name:  String!
   public var last_name: String!
   public var contact: String!
   public var otp: String!
   public var email_address: String!
   public var country: String!
   public var state: String!
   public var city: String!
   public var pin_code: String!
   public var shipping_address: String!
   public var shipping_address2: String!
   public var bill_first_name: String!
   public var bill_last_name: String!
   public var bill_contact: String!
   public var bill_email_address: String!
   public var bill_country: String!
   public var bill_state: String!
   public var bill_city: String!
   public var bill_pin_code: String!
   public var bill_address: String!
   public var bill_address2: String!
   public var status: String!
   public var wallet_point: String!
   public var ref_level1: String!
   public var ref_level2: String!
   public var created_date: String!
   public var created_ip: String!
   public var updated_date: String!
   public var updated_ip: String!
   public var deleted_status: String!
    
}
