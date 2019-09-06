//
//  ChangeMentorViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 21/01/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class ChangeMentorViewController: RootViewController  ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var viewUserbg: UIView!
    @IBOutlet weak var btnProccedMentor: UIButton!
    @IBOutlet weak var lblPhonenumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnGetDetails: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewBG: UIView!
    var  update_mentorcode = String()
    var  update_customercode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        viewUserbg.isHidden = true
        viewBG.layer.cornerRadius = 5
        
        viewBG.layer.borderColor = UIColor.brown.cgColor
        viewBG.layer.borderWidth = 1
       
        btnGetDetails.layer.cornerRadius = 5
        btnProccedMentor.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
        viewUserbg.layer.cornerRadius = 5
        
        viewUserbg.layer.borderColor = UIColor.brown.cgColor
        viewUserbg.layer.borderWidth = 1
        setDoneOnKeyboard()
        let code = getSavedCustomerCode()
        if code != ""{

            update_customercode = code
        }else {
            let alertVc = UIAlertController(title: "", message:"Please login", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                let nextViewControler = storyBoard.instantiateViewController(withIdentifier: "Login")
                self.present(nextViewControler, animated: true, completion: nil)
            }))
            self.present(alertVc, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    @IBAction func didPressedCancelButton(_ sender: Any) {
        txtPhoneNumber.isUserInteractionEnabled = true
        viewUserbg.isHidden = true
        lblPhonenumber.text = ""
        lblName.text = ""
    }
    @IBAction func didPressedmentor(_ sender: Any) {
        updateMentor()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getMentor(phonenumber: String){
        
            startAnimating()
            let dictionary = ["GetMentor": ["mobile": phonenumber]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result:mentorRootClass, error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            let resultUserinof = responsValue.Results[0]
                            self.viewUserbg.isHidden = false
                            self.lblName.text = "\(resultUserinof.first_name ?? "") \(resultUserinof.last_name ?? "")"
                            self.lblPhonenumber.text = "\(resultUserinof.contact ?? "")"
                            self.update_mentorcode  = resultUserinof.code!
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
                        
                        let alertVc = UIAlertController(title: "", message:result.Response[0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let result = result
                        
                        let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
       
        
        
    }
    func updateMentor(){
       
            startAnimating()
            
            let dictionary = ["UpdateMentor": ["mentorcode":update_mentorcode,"customercode":update_customercode]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary){ (result : mentorRootClass , error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            let msg = responsValue.Response[0].response_msg
                            
                            let alertVc = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertVc, animated: true, completion: nil)
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
                        
                        let alertVc = UIAlertController(title: "", message: result.Response[0].response_msg, preferredStyle: .alert)
                        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVc, animated: true, completion: nil)
                    }}
            }
      
        
        
    }
    
}

extension ChangeMentorViewController:UITextFieldDelegate{
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
         txtPhoneNumber.inputAccessoryView = keyboardToolbar
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == txtPhoneNumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}





public struct mentorRootClass : Decodable {
    
    public var Response : [mentorResponse]!
    public var Results : [mentorResult]!
    
}
public struct mentorResult : Decodable{
    
    public var code : String!
    public var contact : String!
    public var email_address : String!
    public var first_name : String!
    public var last_name : String!
    
}
public struct mentorResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
