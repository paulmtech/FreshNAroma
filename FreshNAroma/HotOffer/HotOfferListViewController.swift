//
//  HotOfferListViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 06/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

import AlamofireImage
import Alamofire
import iOSDropDown
import NVActivityIndicatorView
import TransitionButton
class HotOfferListViewController: RootViewController ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    var tableOffersViewData = [OffersResult]()
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //API GET REQEST
        api.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
       
        tableView.register(UINib(nibName: "ProductViewTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTopSaversItem()
        btnBasket.badge = String(BasketData.badge)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTopSaversItem() {
        
            startAnimating()
            let dictionary = ["TopSavers": [:]]
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]) { (result : OffersRootClass, error)  in
            
                DispatchQueue.main.async {
                    self.stopAnimating()
                }
                if case .success = error {
                    let responsValue = result
                    if responsValue.Response[0].response_code == "1"{
                        self.tableOffersViewData = (responsValue.Results)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                        }
                    } else if responsValue.Response[0].response_code == "0"{
                        let alert = UIAlertController(title: "FreshNAroma", message: responsValue.Response[0].response_msg, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                if case .failure = error{
                    let alert = UIAlertController(title: "FreshNAroma", message: Constants.ALERT_SERVER_ERROR, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        
    }
    
    

}

extension HotOfferListViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return tableOffersViewData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                 for: indexPath) as! ProductViewTableViewCell
        let  cellData = tableOffersViewData[indexPath.row]
        cell.displayProductCell(cellData)
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnProductImage.tag = indexPath.row
        cell.btnProductImage.addTarget(self, action: #selector(didPressedProductButton), for: .touchUpInside)
        
        return cell
    }

    @objc func didPressedProductButton(sender: UIButton){
        
      
        let storyBoardId =  "HotOfferDetailViewController"
        
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! HotOfferDetailViewController
        let  cellData = tableOffersViewData[sender.tag]
        
        nextViewControler.productItems =  [cellData];
        nextViewControler.isJson = false
        nextViewControler.isOffer = true
        nextViewControler.isProduct = false
        
        self.navigationController?.pushViewController(nextViewControler, animated: true)
       
    }
  
    
    @IBAction func didPressedBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    public  func getUserCode() -> String{
        var  userID = ""
        let dict_UserInformation = UserDefaults.standard.value(forKey: UserDefaulKey.userdict)
        let userCode = dict_UserInformation as? [String : AnyObject]
        
        if userCode != nil {
            userID =  (userCode![UserDefaulKey.code]! as? String)!
        }
        return userID
    }
    @IBAction func buttonAction(_ button: TransitionButton) {
        let productItem = tableOffersViewData[button.tag]
        button.startAnimation()
        self.view.isUserInteractionEnabled = false
        
        let dictionary = ["AddtoCart":["id" : productItem.id!,"sessionid":sessionId!,"quantity":"1","code": getUserCode()]]
        
        api.fetchApiResult(viewController: self, paramDict: dictionary) { (result : addcartRootClass, error) in
            button.stopAnimation()
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
            }
            if case .success = error {
                let responsValue = result
                if responsValue.Response[0].response_code == "0"{
                     DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: responsValue.Response[0].response_msg, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    }
                }
                else if responsValue.Response[0].response_code == "1"{
                    DispatchQueue.main.async {
                        BasketData.badge = Int(responsValue.Item)!
                        self.btnBasket.badge = String(BasketData.badge )
                        let alert = UIAlertController(title: "", message: "Item added", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}



