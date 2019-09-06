 //
//  FranchiseViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 22/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
 class FranchiseViewController: RootViewController ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var txtName: UITextField!
    let api = APIRequestFetcher()
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
         setDoneOnKeyboard()
        api.delegate = self
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
     @IBAction func didPressedSubmit(_ sender: Any) {
        if txtName.text?.count == 0 {
            let alertVc = UIAlertController(title: "", message: "Enter Name", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        } else if txtMobile.text?.count == 0 {
            let alertVc = UIAlertController(title: "", message: "Enter Mobile Number", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }else if txtEmail.text?.count == 0 {
            let alertVc = UIAlertController(title: "", message: "Enter Email", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }else if txtMobile.text!.count < 10 {
            let alertVc = UIAlertController(title: "", message: "Enter valid Mobile Number", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }else if !(txtEmail.text?.isValidEmail)! {
            let alertVc = UIAlertController(title: "", message: "Enter valid Email", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
        else{
            startAnimating()
            let ipAddress = getIPAddress()
            
            let dictionary = ["Frachise_Enquiry":["name": txtName.text!,"email":txtEmail.text!,"mobile": txtMobile.text!,"created_ip": ipAddress]]
            api.fetchApiResult(viewController: self, paramDict: dictionary)
                {(result : EnquiryRootClass ,error) in
                if case .success = error {
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        let result = result
                        
                        if result.Response[0].response_code == "1"{
                        let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                        } else if result.Response[0].response_code == "0"{
                            let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
                        }
                        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}
extension FranchiseViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        activeField = textField
//
//        lastOffset = self.scrollView1.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
      //  activeField = nil
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && string == " ") {
            return false;
        }
        
        if textField == txtMobile {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func setDoneOnKeyboard() {
        
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        txtMobile.inputAccessoryView = keyboardToolbar
        txtMobile.keyboardType = .phonePad
        txtEmail.keyboardType = .emailAddress
        txtName.inputAccessoryView = keyboardToolbar
        txtEmail.inputAccessoryView = keyboardToolbar
        
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
public struct EnquiryRootClass : Decodable {
    
    public var Response : [EnquiryResponse]!
    public var Results : EnquiryResult!
    
}
public struct EnquiryResult : Decodable {
    
    public var created_date : String!
    public var created_ip : String!
    public var email : String!
    public var mobile : String!
    public var name : String!
    
}
public struct EnquiryResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
