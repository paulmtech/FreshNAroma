//
//  EditAddressViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 03/06/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditAddressViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtPinCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress1: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress2: SkyFloatingLabelTextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var pickerViewData = ["1","2","3"]
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txtPinCode.inputView = pickerView
        
        setDoneOnKeyboard()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    @objc func didTapView(gesture : UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didPressedCloseButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        txtPinCode.keyboardType = .phonePad
       }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension EditAddressViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtPinCode.text = pickerViewData[row]
    }
//    private func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerViewData[row]
//    }
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        txtPinCode.text = pickerViewData[row]
//    }
}
