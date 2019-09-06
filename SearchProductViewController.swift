//
//  SearchProductViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 22/05/19.
//  Copyright © 2019 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

//import UIKit
//import TransitionButton
//import AlamofireImage
//import Alamofire
//
//class SearchProductViewController: UIViewController {

//
//  SearchProductViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 27/11/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SafariServices
import AlamofireImage
import TransitionButton

public struct SearchProductRootClass : Decodable {
    
    public var Response : [SearchProductResponse]!
    public var Results : [SearchProductResult]!
    
}
public struct SearchProductResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct SearchProductResult : Decodable {
    
    public var category : String!
    public var id : String!
    public var pdt_code : String!
    public var pdt_name : String!
    public var sub_category : String!
    
}
class SearchProductViewController: RootViewController,UITableViewDelegate,UITableViewDataSource ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var searchText = String()
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [JSON]() {
        didSet {
            setupTableViewBackgroundView()
            tableView.reloadData()
            
        }
    }
    
    
    @IBOutlet weak var viewNoStacksAvailable: UIView!
    @IBOutlet weak var LoadingView: UIView!
    private let searchController = UISearchController(searchResultsController: nil)
    private let apiFetcher = APIRequestFetcher()
    private var previousRun = Date()
    private let minInterval = 0.05
    var searchType = String()
    var searchSpecialProduct = [String : String]()
    var currentPage = String()
    var totalPage = Int()
    var totalrecords = Int()
    var searchBarText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        apiFetcher.delegate = self
        viewNoStacksAvailable.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        tableView.tableFooterView = UIView()
        currentPage = "1"
        //setupTableViewBackgroundView()
        fetchResults(for: searchText, page: currentPage)
        LoadingView.isHidden = true
        tableView.register(UINib(nibName: "ProductViewTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
    }
    private func setupTableViewBackgroundView() {
        
        
        let backgroundViewLabel = UILabel(frame: .zero)
        if searchResults.count < 1 {
            backgroundViewLabel.text = " Sorry! No record found. "
        } else {
            backgroundViewLabel.text = ""
        }
        
        
        backgroundViewLabel.textColor = .darkGray
        backgroundViewLabel.numberOfLines = 0
        
        backgroundViewLabel.textAlignment = NSTextAlignment.center
        backgroundViewLabel.font.withSize(20)
        tableView.backgroundView = backgroundViewLabel
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell",
                                                 for: indexPath) as! ProductViewTableViewCell
        cell.lblTitle.text = searchResults[indexPath.row]["pdt_name"].stringValue
        
        let discount = (searchResults[indexPath.row]["disc"].string! as NSString ).floatValue
        if discount > 0 {
            cell.lblSaved.text = String(" You Save \(RupeeSymbol)\(discount) ")
            
            cell.lblSaved.isHidden = false;
            
            
        } else {
            cell.lblSaved.isHidden = true;
        }
        
        
        let pdt_price = (searchResults[indexPath.row]["selling_price"].string! as NSString).floatValue
        
        cell.lblPrice.text = String("\(RupeeSymbol)\(pdt_price)")
        
        let mrp : Float = (searchResults[indexPath.row]["mrp"].string! as NSString ).floatValue
        if(pdt_price < mrp) {
            cell.lblMrp.text = String("MRP:\(RupeeSymbol)\(mrp)")
            let attributedString = NSMutableAttributedString(string:  cell.lblMrp.text!)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            cell.lblMrp.attributedText = attributedString
            
        }else{
            cell.lblMrp.isHidden = true
        }
        
        
        let url = searchResults[indexPath.row]["productimage"].string
        let urlStr : NSString = url!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        
        cell.imgProduct.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: cell.imgProduct.frame.size))
        
        cell.lblSaved.layer.cornerRadius = 10.00
        cell.lblSaved.clipsToBounds = true
        cell.btnAdd.spinnerColor = .white
        cell.btnAdd.cornerRadius = 5.00
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.btnProductImage.tag = indexPath.row
        cell.btnProductImage.addTarget(self, action: #selector(didPressedProductButton), for: .touchUpInside)
        return cell
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
    @objc func buttonAction(_ button: TransitionButton) {
        
        let productItem  = searchResults[button.tag] as JSON
       
        let pid : String = "\(productItem["id"])"
        button.startAnimation()
        self.view.isUserInteractionEnabled = false
        
        let dictionary = ["AddtoCart":["id":pid,"sessionid":sessionId!,"quantity":"1","code": getUserCode()]]
        
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
        let  cellData = searchResults[sender.tag]
        nextViewControler.searchItemJson = [cellData]
        nextViewControler.isJson = true
        nextViewControler.isOffer = false
        nextViewControler.isProduct = false
        
        self.navigationController?.pushViewController(nextViewControler, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyBoardId =  "HotOfferDetailViewController"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! HotOfferDetailViewController
        let  cellData = searchResults[indexPath.row]
        nextViewControler.searchItemJson = [cellData]
        nextViewControler.isJson = true
        nextViewControler.isOffer = false
        nextViewControler.isProduct = false
        self.navigationController?.pushViewController(nextViewControler, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == searchResults.count - 1{
            if getNextPage(page: currentPage){
             
                if !searchBarText.isEmpty{
                    fetchResults(for: searchBarText, page: currentPage)
                }
            }
        }
    }
    func getNextPage(page: String) -> Bool{
        
        if Int(currentPage)! < Int(totalPage) {
            currentPage = ("\(Int(currentPage)! + 1)")
            return true
        }
        return false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    func fetchResults(for text: String , page: String) {
      
        LoadingView.isHidden = false
        
        apiFetcher.searchProduct(searchText: text, searchPage: page){
            results, error in
            self.LoadingView.isHidden = true
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            
            let resultRespons = results["result"]
            
            let resultValue = resultRespons["Response"]
            
            if resultValue[0]["response_code"].string! == "0"{
                self.viewNoStacksAvailable.isHidden = false
            } else if resultValue[0]["response_code"].string! == "1"{
                
                self.searchResults.append(contentsOf: resultRespons["Results"].array!)
                let pageInfo = resultRespons["PageInfo"].array!
                self.currentPage = pageInfo[0]["currentpage"].string!
                self.totalPage = pageInfo[0]["totalpage"].int!
                self.totalrecords = pageInfo[0]["totalrecords"].int!
            }else {
                return
            }
        }
    }
}
