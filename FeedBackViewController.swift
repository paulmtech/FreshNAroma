//
//  FeedBackViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 15/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
@objc protocol loadStareDelegate {
 func showStareRatingView()
}

class FeedBackViewController: RootViewController {
    weak var delegate: loadStareDelegate?
    let placeholder = "Good"
    var billNo = String()
    var rating = String()
    var feedbackText = String()
    @IBOutlet weak var viewRatebg: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet var floatRatingView: FloatRatingView!
    var api = APIRequestFetcher()
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
    }
var starRating = Double()
    override func viewWillAppear(_ animated: Bool) {
        floatRatingView.backgroundColor = UIColor.clear
        txtView.returnKeyType = UIReturnKeyType.done
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings
        viewRatebg = setCornerRadius(view: viewRatebg)
        floatRatingView.maxRating = 5
        floatRatingView.minRating = 1
        txtView = (setCornerRadius(view: txtView) as! UITextView)
        
        if feedbackText.count > 0 {
            txtView.text =  feedbackText
           
        }else {
            txtView.text =  placeholder
            txtView.textColor = .gray
        }
        
        let starRated = (Double(rating))!
      
        starRating =  starRated > 0 ? starRated : 2
       
        floatRatingView.rating = starRating
        view?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
         starRating  = 2
    }

    @IBAction func didPressedOkButton(_ sender: Any) {
        
        
        let comment = txtView.text
        let rateing = "\(starRating)"
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
          let  userID =  (userCode![UserDefaulKey.code]! as? String)!
            submitRate(userID: userID, billno: billNo, rateing: rateing, comment: comment!)
        }else {
            return
        }
        
      
        
    }
    
    @IBAction func didPressedCancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    
    }
}
extension FeedBackViewController: FloatRatingViewDelegate {
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
       starRating = rating
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
      starRating = rating
    }
    
}

extension FeedBackViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        txtView.textColor = .black
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            
            textView.resignFirstResponder()
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars <= 160  {
            guard range.location == 0 else {
                return true
            }
            let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
            return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
           
        }else {
            return false
        }
        //return numberOfChars < 160
       
        
        // 10 Limit Value
    }
    
    func submitRate(userID: String,billno:String,rateing : String,comment : String){
        
        let dictionary = ["OrderRating":["billno": billNo, "customercode":userID,"rating":rateing,"comments": comment]]
//        DispatchQueue.main.async {
//         self.startAnimating()
//        }
        api.fetchApiResult(viewController: self, paramDict: dictionary)
        { (result : UserInfoRootClass, error) in
            
        
            DispatchQueue.main.async {
                self.stopAnimating()
                self.dismiss(animated: false, completion: nil)
            }
            if case .success = error {
                if result.Response[0].response_code == "1"{
                    self.delegate?.showStareRatingView()
                }
            }
    }
}
}
