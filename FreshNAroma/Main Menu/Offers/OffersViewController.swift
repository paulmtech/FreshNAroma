//
//  OffersViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 10/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import TransitionButton
import AlamofireImage
import Alamofire

class OffersViewController: RootViewController,SubMenuListDelegate ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
   // var categoryId = String()
    var tableOffersViewData = [OffersResult]()
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    func didAddButtonTapped(btn: UIButton) {
        
    }
    
    func didMinusButtonTapped(btn: UIButton) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
       tableView.register(UINib(nibName: "ProductViewTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
        getTopSaversAPICall()
    }
    
    //TopSavers
    func getTopSaversAPICall() {
        if  Connectivityy.isConnectedToInternet{
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
                            // self.collectionOffersView.reloadData()
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
        } else {
            let alert = UIAlertController(title: "FreshNAroma", message: Constants.ALERT_NETWORK_ERROR, preferredStyle: UIAlertController.Style.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}

extension OffersViewController : UITableViewDataSource,UITableViewDelegate{
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
        
        cell.lblTitle.text = cellData.pdt_name
        
        
        
        
        let pdt_price = (cellData.selling_price as NSString).floatValue
        cell.lblPrice.text = String(format: "\(RupeeSymbol)%.2f",pdt_price)
        let discount = floatFromString(stringValue:cellData.disc)
        if discount > 0 {
            cell.lblSaved.text = String(format:" You Save \(RupeeSymbol)%.2f ",discount)
            
            cell.lblSaved.isHidden = false;
            
            
        } else {
            cell.lblSaved.isHidden = true;
        }
        let mrp : Float = (cellData.mrp as NSString ).floatValue
        if(pdt_price < mrp) {
            cell.lblMrp.text = String(format: "MRP:\(RupeeSymbol)%.2f",mrp)
            let attributedString = NSMutableAttributedString(string:  cell.lblMrp.text!)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            cell.lblMrp.attributedText = attributedString
            cell.lblMrp.isHidden = false
            
        }else{
            cell.lblMrp.isHidden = true
        }
        
        
        let url = cellData.productimage
        let urlStr : NSString = url!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        
        cell.imgProduct.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: cell.imgProduct.frame.size))
        
        cell.viewSaved.layer.cornerRadius = 10.00
        cell.viewSaved.clipsToBounds = true
        cell.imgProduct.layer.cornerRadius = 2
        cell.imgProduct.clipsToBounds = true
        cell.imgProduct.layer.borderWidth = 0.05
        
        cell.btnAdd.spinnerColor = .white
        cell.btnAdd.cornerRadius = 5.00
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnProductImage.tag = indexPath.row
        cell.btnProductImage.addTarget(self, action: #selector(didPressedProductButton), for: .touchUpInside)
        
        return cell
    }
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
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
        
        let dictionary = ["AddtoCart":["id":productItem.id!,"sessionid":sessionId!,"quantity":"1","code": getUserCode()]]
        
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
public struct OffersRootClass : Decodable {
    
    public var Response : [OffersResponse]!
    public var Results : [OffersResult]!
    
}
public struct OffersResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct OffersResult : Decodable {
    
    
    public var id : String!
    public var  district : String!
    public var  hsn_code : String!
    public var pdt_code : String!
    public var  category : String!
    public var sub_category : String!
    public var  pdt_name : String!
    public var  pdt_name_tamil : String!
    public var pdt_description : String!
    public var  pdt_unit : String!
    public var  pdt_weight_kg : String!
    public var pdt_weight_ltr : String!
    public var pdt_type : String!
    public var pdt_barcode : String!
    public var pdt_price : String!
    public var selling_price : String!
    public var mrp : String!
    public var disc : String!
    public var cgst : String!
    public var sgst : String!
    public var available : String!
    public var batch : String!
    public var profile_picture : String!
    public var gst_slab: String!
    public var cmp_commission: String!
    public var selling_percent: String!
    public var warehouse_percent: String!
    public var unit_percent: String!
    public var unit_sales_price: String!
    public var wh_sales_price: String!
    public var status: String!
    public var visible: String!
    public var barcode_status: String!
    public var approve_status: String!
    public var updated_date: String!
    public var updated_by: String!
    public var updated_ip: String!
    public var productimage: String!
    
}
