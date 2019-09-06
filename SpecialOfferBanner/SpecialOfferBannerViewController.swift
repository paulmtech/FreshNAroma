//
//  SpecialOfferBannerViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 28/06/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AlamofireImage
import Alamofire
class SpecialOfferBannerViewController: UIViewController,NVActivityIndicatorViewable,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
         self.stopAnimating()
        if result == Constants.apiReturnerror{
        let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    var bannerId = String()
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imagView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getBanner()
        api.delegate = self
    }

    @IBAction func didPressedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getBanner(){
        startAnimating()
        let dictionary = ["ViewBanner": ["id": bannerId]]
        
        api.fetchApiResult(viewController: self, paramDict: dictionary) { (result : ViewBannerRootClass , error) in
            
            DispatchQueue.main.async {
                self.stopAnimating()
            }
            if case .success = error {

                let responsValue = result

                if responsValue.Response[0].response_code == "1"{
                    DispatchQueue.main.async {
                    let banner: ViewBannerResult = responsValue.Results[0]


                    self.lblDescription.text = banner.url
                    let urlStr : NSString = banner.imageurl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
                    self.imagView.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: self.imagView.frame.size))
                    }
                }
            }
        }
   }
    

}
public struct ViewBannerRootClass: Decodable {
    
    public var Response : [ViewBannerResponse]!
    public var Results : [ViewBannerResult]!
    
}
public struct ViewBannerResult: Decodable {
    
    public var bannertype : String!
    public var image : String!
    public var imageurl : String!
    public var product : String!
    public var url : String!
    
}
public struct ViewBannerResponse: Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
