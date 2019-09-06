//
//  SubCategoryProductsViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 24/11/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import TransitionButton
import AlamofireImage
import Alamofire
public struct addcartRootClass : Decodable {
    
    public var Response : [addcartResponse]!
    public var Item : String!
}
public struct addcartResponse : Decodable  {
    
    public var response_code : String!
    public var response_msg : String!
    
}

class SubCategoryProductsViewController: RootViewController,SubMenuListDelegate ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var categoryId = String()
   
    var navigationTitle = String()
    func didAddButtonTapped(btn: UIButton) { }
    let api = APIRequestFetcher()
    func didMinusButtonTapped(btn: UIButton) { }
    let button = TransitionButton(frame: CGRect(x: 100, y: 100, width: 400, height: 40))
    var tableViewData = [OffersResult]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    @IBOutlet var viewNoResult: UIView!
    //@IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        viewNoResult.isHidden = true
        lblNavigationTitle.text = navigationTitle
        categoryId = categoryId == "" ? "5" : categoryId
        getsubcategoryAPICall()
         tableView.register(UINib(nibName: "ProductViewTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewNoResult.isHidden = true
        self.btnBasket.badge = String(BasketData.badge )
    }
    
    
    func getsubcategoryAPICall()  {
        //startAnimating(s, "Loading...")
        
        if  Connectivityy.isConnectedToInternet{
            startAnimating()
            
            let longstring = authParameter()!
            
            let dictionary = ["SubcategoryProducts": ["subcategory":"\(categoryId)","page" : "1"]]
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            //            let jsonS = "{\"Category_Menu\":{}}"
            let plainData1: Data? = jsonString!.data(using: .utf8)
            let digest2 = plainData1?.base64EncodedString(options: [])
            let qry = "Case=\(digest2 ?? "")"
            let jsonUrlString = "\(baseUrl)\(longstring)&\(String(describing: qry))"
            guard let url = URL(string: jsonUrlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
              DispatchQueue.main.async  {
                    self.stopAnimating()
                }
                
                guard let data = data else {
                    return
                }
                
                do{
                    
                    let responsValue = try JSONDecoder().decode(SubcategoryProductsRootClass.self, from: data)
                   
                    
                    if responsValue.Response[0].response_code == "1" {
                        //let data = responsValue.Results as? OffersResult
                        self.tableViewData = (responsValue.Results)
                        DispatchQueue.main.async {
                            self.chekTabledate()
                            self.tableView.reloadData()
                            
                        }
                        
                        
                        
                    }else  if responsValue.Response[0].response_code == "0"{
                        self.chekTabledate()
                    }
                    
                } catch  {
                   
                }
            }
            task.resume()
        }else{
            let alert = UIAlertController(title: "FreshNAroma", message: Constants.ALERT_NETWORK_ERROR, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func chekTabledate(){
        
        if tableViewData.count == 0 {
            DispatchQueue.main.async {
                self.viewNoResult.isHidden = false
            }
            
        }else {
            DispatchQueue.main.async {
                self.viewNoResult.isHidden = true
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return tableViewData.count
//    }
    func addToBasket(product : OffersResult ){
        
        let basketItems =  BasketData.userSelectedItems
        var iteminfo = itemFromDecodeObject(product: [product])
        let id = iteminfo[ProductInfo.pdt_code.rawValue]
        let filteredArray = basketItems.filter({ $0["pdt_code"] == id  })
        if filteredArray.count == 0 {
            // var addItem = insertItemToBasket(product: iteminfo )
            BasketData.badge += 1
            iteminfo["qty"] = getPQty(qty: (iteminfo["qty"]!))
            BasketData.userSelectedItems.append(iteminfo)
            btnBasket.badge = String( BasketData.badge )
        }else {
            var item = filteredArray[0]
            if let index1 = BasketData.userSelectedItems.index(of: item) {
                item["qty"] = getPQty(qty: (item["qty"]!))
                BasketData.userSelectedItems[index1] = item
            }
        }
        
        
        
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
        let productItem = tableViewData[button.tag]
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
    
    
    @objc func didPressedProductButton(sender: UIButton){
        
       
        let storyBoardId =  "HotOfferDetailViewController"
        
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! HotOfferDetailViewController
        let  cellData = tableViewData[sender.tag]
        nextViewControler.productItems = [cellData]
        nextViewControler.isJson = false
        nextViewControler.isOffer = true
        nextViewControler.isProduct = false
        self.navigationController?.pushViewController(nextViewControler, animated: true)
        
    }

    
    
    
    
    
 
    
    
    
}
extension UIView {
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension SubCategoryProductsViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                 for: indexPath) as! ProductViewTableViewCell
        let  cellData = tableViewData[indexPath.row]
        
        cell.lblTitle.text = cellData.pdt_name
        
        
        
        
        let pdt_price = (cellData.selling_price! as NSString).floatValue
        cell.lblPrice.text = String(format: "\(RupeeSymbol)%.2f",pdt_price)
        let discount = floatFromString(stringValue:cellData.disc!)
        if discount > 0 {
            cell.lblSaved.text = String(format:" You Save \(RupeeSymbol)%.2f ",discount)
            
            cell.lblSaved.isHidden = false;
            
            
        } else {
            cell.lblSaved.isHidden = true;
        }
        let mrp : Float = (cellData.mrp! as NSString ).floatValue
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
   
    
    
    @IBAction func didPressedBack(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

}
