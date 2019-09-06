//
//  PaymentRazorViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 12/06/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import Razorpay
protocol PaymentDelegate: AnyObject {
    func paymentid(_ id: String, amount : String)
}
class PaymentRazorViewController: UIViewController,RazorpayPaymentCompletionProtocol {
    weak var delegate : PaymentDelegate?
     var razorpay: Razorpay!
     var payAmount = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = Razorpay.initWithKey("rzp_test_W57UXqJ4CJnQwc", andDelegate: self)
        showPaymentForm()
    }

        internal func showPaymentForm(){
            var amount = Float(payAmount)
            amount = amount! * 100.00;
            let options: [String:Any] = [
                "amount" : amount as Any, //mandatory in paise
                "description": "Amount Payable",
                "image": "http://www.freshnaroma.com/img/logo_pay.png",
                "name": "FRESH N AROMA",
                "prefill": [
                    "contact": "9797979797",
                    "email": "foo@bar.com"
                ],
                "theme": [
                    "color": "#F7C233"
                ]
            ]
            //razorpay.open(options)
            razorpay.open(options, displayController: self)
        }
        public func onPaymentError(_ code: Int32, description str: String){
            let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
        public func onPaymentSuccess(_ payment_id: String){
            delegate?.paymentid(payment_id, amount: payAmount)
            let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }

    @IBAction func didPressedBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
