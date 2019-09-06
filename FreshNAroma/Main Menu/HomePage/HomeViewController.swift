//
//  HomeViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 03/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import Nuke
import SideMenuSwift
import ImageSlideshow
import AlamofireImage
import Alamofire
import iOSDropDown
import NVActivityIndicatorView
import TransitionButton
import Kingfisher


struct BannerApi: Decodable {
    
    let Response : [BannerResponse]
    let Results : [BannerResult]
    
}
struct BannerResult: Decodable {
    
    let created_by : String?
    let created_date : String?
    let created_ip : String?
    let id : String?
    let image : String?
    let imageurl : String?
    let status : String?
    let bannertype : String?
    let product : String?
    
}
struct BannerResponse: Decodable {
    
    let response_code : String?
    let response_msg : String?
    
}
class HomeViewController: RootViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var smallIconData = [[:]]
    var tableViewData = [CategoryResult]()
    var tableOffersViewData = [OffersResult]()
    var arrayDistric = [DistrickResult()]
   
    var alamofireSourcestring = [String]()
    var districkTableData = [DistrickResult]()
    var alamofireSource = [KingfisherSource]()
    var banners = [BannerResult]()
    var api = APIRequestFetcher()
    var currentPage = Int()
    @IBOutlet weak var slideShow: ImageSlideshow!
    
    @IBOutlet weak var btnShowMoreProduct: UIButton!
    
    @IBOutlet weak var slideShow1: ImageSlideshow!

    @IBOutlet weak var specialOfferTableview: UITableView!
    
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var hotOffersCollectionView: UICollectionView!{
        didSet{
            
            hotOffersCollectionView.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1) .cgColor
            hotOffersCollectionView.layer.borderWidth = 1;
        }
    }
    @IBOutlet weak var smallIconcollectionView: UICollectionView!
    
    
    @IBOutlet weak var txtdropDown: DropDown!
    
    
    @IBOutlet weak var viewBgDistrick: UIView!
    
    
    
    @IBOutlet weak var districkTableview: UITableView!
    
    override func viewDidLoad() {
     super.viewDidLoad()
        slideShow1.delegate = self
        api.delegate = self
        specialOfferTableview.tableFooterView = UIView()
        
        specialOfferTableview = (setViewBorder(view: specialOfferTableview, bradious: 5, bwidth: 1, bcolor: UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 0.5)) as! UITableView)
        btnViewMore = (setViewBorder(view: btnViewMore, bradious: 1, bwidth: 1, bcolor: UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 0.5)) as! UIButton)
        
        specialOfferTableview.register(UINib(nibName: "ProductViewTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        
        btnShowMoreProduct = ((setViewBorder(view: btnShowMoreProduct, bradious: 10, bwidth: 1, bcolor: UIColor.white)) as! UIButton)
        
       smallIconcollectionView = ((setViewBorder(view: smallIconcollectionView, bradious: 0, bwidth: 1, bcolor: UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 0.5))) as! UICollectionView)
       checkAppVersion()
        }
    
    
    
    
    
    func checkAppVersion() {
        let appBuildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        let dictionary = ["check_version_IOS": [:]]
        api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]])  { (result: CheckVersionRootClass , erorr) in
        if case .success = erorr {
       
            let responsValue = result
            if responsValue.Response[0].response_code == "1"{
                
                if responsValue.Data.latestversion != appBuildVersion {
                
                    if responsValue.Data?.force_upgrade == "true" {
                    let alert = UIAlertController(title: "FreshNAroma", message:"You are using older version of App. Kindly upgrade" , preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/freshn-aroma/id1440983596?ls=1")!, options: [:], completionHandler: nil)
                            
                        }))
                                self.present(alert, animated: true, completion: nil)
                
                    }else{
                let alert = UIAlertController(title: "FreshNAroma", message:"You are using older version of App. Do you want to upgrade now" , preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                            UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/freshn-aroma/id1440983596?ls=1")!, options: [:], completionHandler: nil)
                            
                        }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        
                        
                self.present(alert, animated: true, completion: nil)
                }
                }
                
            }

            }
    }
    }
    @IBAction func didPressedViewMore(_ sender: Any) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
        
        loadHomeviewApis()
    }
    
    func loadHomeviewApis() {
        
     
        getBannerAPICall()
        getcategoryAPICall()
        getCartcount()
        getTopSaversAPICall()
        getDistric()
        

    }
    
    func getCartcount(){
       
            startAnimating()
            let dictionary = ["CartMenu": ["sessionid": sessionId]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]){ (result : BasketDataRootClass, error)  in
                DispatchQueue.main.async {
                    self.stopAnimating()
                }
                if case .success = error {
                    let responsValue = result
                    if responsValue.Response[0].response_code == "1"{
                        let resultData = responsValue.cartinfo!
                        DispatchQueue.main.async(execute: {
                            BasketData.badge = Int(resultData.cartcount)
                            self.btnBasket.badge = String(BasketData.badge)
                        })
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
    
    func getBannerAPICall(){
      
              startAnimating()
             let dictionary = ["Banners": [:]]
             alamofireSource.removeAll()
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]){ (result: BannerApi, error)  in
                DispatchQueue.main.async {
                    self.stopAnimating()
                }
                if case .success = error {
                    
                    let responsValue = result
                    if responsValue.Response[0].response_code == "1"{
                        
                        self.banners = responsValue.Results
                        for i in 0..<responsValue.Results.count{
                           
                            let urlImageString: String = responsValue.Results[i].imageurl!
                            let urlimgeStr : NSString = urlImageString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
                            let imgeurl = URL(string: urlimgeStr as String)
                            
                           // print("image URL \(imgeurl!)")
                           // self.alamofireSource.append( KingfisherSource(urlString: urlimgeStr as String)!)
                            self.alamofireSource.append( KingfisherSource(urlString: urlimgeStr as String, placeholder: UIImage(named: appPlaceholerImage), options: nil)!)
                            
                            //self.alamofireSource.append(AlamofireSource(url: imgeurl!, placeholder: UIImage(named: appPlaceholerImage)))
                            
                        }
                        self.bannerView(slideView: self.slideShow1)
                        
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
    
    

    
    @IBAction func tapGusterpressed(_ sender: Any) {
        
    }
    
    
    
 
    

   // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == smallIconcollectionView {
           
           return smallIconData.count

        }
        if collectionView == hotOffersCollectionView {
           return tableViewData.count
        }
        
        return 0
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          if collectionView == smallIconcollectionView {
        
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeSmallIconScrollCollectionViewCell
            let cellData = smallIconData[indexPath.row]
            cell.image.image = UIImage.init(named: cellData["image"] as! String)
            cell.lblTitle.text = "\(cellData["title"] as! String)"
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 0.8) .cgColor
            
        return cell
        }
        
        if collectionView == hotOffersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotOfferCell", for: indexPath) as! HotOffersCollectionViewCell
            let  cellData = tableViewData[indexPath.row]
            cell.lblTitle?.text = cellData.category
            let url = URL(string: cellData.categoryimage)
//            let placeholder = UIImage(named: appPlaceholerImage)
//            let totalwidth = collectionView.bounds.size.width;
//            let numberOfCellsPerRow =  3
//            let dimensions = CGFloat(Int(totalwidth-2) / numberOfCellsPerRow)
//            let filter = AspectScaledToFillSizeFilter(size: CGSize(width: dimensions, height: 110))
//            cell.image.af_setImage(withURL: url!, placeholderImage: placeholder, filter: filter)
           // cell.image.af_setImage(withURL: url!)
            
            //cell.image.load(url: url!)
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "appPlaceholerImage"),
                transition: .fadeIn(duration: 0.33)
            )
            Nuke.loadImage(with: url!, options: options, into: cell.image)
            //Nuke.loadImage(with: url!, into: cell.image)
            
          //  cell.image.image =   resizeImage(image: cell.image.image!, targetSize: cell.image.frame.size)
            

            //cell.lblTitle.text = indexPath.row % 2 == 0 ? "text text" : "text text text text text text text text text"
            return cell
        }
       /* if collectionView == collectionOffersView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryItemCollectionViewCell", for: indexPath) as! SubCategoryItemCollectionViewCell
         //   cell.cellDelegate = self
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1.0) .cgColor
            let  cellData = tableOffersViewData[indexPath.row]
            cell.lblPdtName?.text = cellData.pdt_name
            let imageString = cellData.productimage!
            let urlStr : NSString = imageString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
            cell.imgProductimage.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: cell.imgProductimage.frame.size))
            let pdt_price = (cellData.selling_price! as NSString ).floatValue
            cell.lblSellingPrice.text = String("\(RupeeSymbol)\(pdt_price)")
            
            let mrp : Float = (cellData.mrp! as NSString ).floatValue
            if(pdt_price < mrp) {
                cell.lblMrp.text = String("MRP:\(RupeeSymbol)\(mrp)")
                let attributedString = NSMutableAttributedString(string: cell.lblMrp.text!)
                // Swift 4.2 and above
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                cell.lblMrp.attributedText = attributedString
            }else {
                cell.lblMrp.isHidden = true
            }
            
//            cell.btnAddtoCart.cornerRadius = 20.00
//            cell.btnAddtoCart.spinnerColor = .white
            cell.btnProductImage.tag = indexPath.row
//            cell.btnAddtoCart.tag = indexPath.row
            cell.btnProductImage.addTarget(self, action: #selector(didPressedProductButton), for: .touchUpInside)
//            cell.btnAddtoCart.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            return cell
        }*/
        return UICollectionViewCell()
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
                DispatchQueue.main.async {
                    
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == hotOffersCollectionView {
       
        let storyBoardId =  "SubCategoryViewController"
        let  cellData = tableViewData[indexPath.row]
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SubCategoryViewController
        let actionDict =  ["Subcategory": ["category":"\(cellData.id!)"]] as [String : AnyObject]
        nextViewControler.actionDictionary = actionDict
        nextViewControler.navigationTitle = cellData.category
        self.navigationController?.pushViewController(nextViewControler, animated: true)
     } else if collectionView == smallIconcollectionView {
        let id = Int(indexPath.row) + 1
        //let searchProducts = ["SearchProducts": ["type":"special","id":"\(id)","name":"pregnantwomens","page":"1"]]
       
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        var storyBoardId = String()
        storyBoardId = "SearchResultsTableViewController"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SearchResultsTableViewController
        nextViewControler.searchType = "special"
        nextViewControler.searchSpecialProduct = ["id":"\(id)","name":"pregnantwomens","page":"1"]
        self.navigationController?.pushViewController(nextViewControler, animated: false)
        
        }
        
}
    // MARK: UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == hotOffersCollectionView {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow =  3
        let dimensions = CGFloat(Int(totalwidth-2) / numberOfCellsPerRow)
            return CGSize(width: dimensions+40, height: 148.5)
         }else if collectionView == smallIconcollectionView {
           return CGSize(width:150, height: 90)
         }
        
       return CGSize(width: 166, height: 112)
    }
    
    
    
    
    func bannerView (slideView: ImageSlideshow) {
        
        DispatchQueue.main.async {
        slideView.slideshowInterval = 2.0
        slideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideView.contentScaleMode = UIView.ContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideView.pageIndicator = pageControl
    
       
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideView.activityIndicator = DefaultActivityIndicator()
        slideView.currentPageChanged = { page in
          
        }
       
            slideView.setImageInputs(self.alamofireSource)
            slideView.zoomEnabled = false;
            slideView.contentScaleMode = .scaleToFill
           
            
           // self.currentPage = String(format: "%d", slideView.currentPage)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didTap))
        slideView.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func didTap() {
        
        
        let result = banners[currentPage]
        print("ProductType\(result.bannertype!)")
        if result.bannertype == "2"{
        
     
        let storyBoardId =  "HotOfferDetailViewController"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! HotOfferDetailViewController
        nextViewControler.isJson = false
        nextViewControler.isOffer = false
        nextViewControler.isProduct = true
        nextViewControler.product_id = result.product!
        self.navigationController?.pushViewController(nextViewControler, animated: true)
        } else if result.bannertype == "1"{
            let offerView = SpecialOfferBannerViewController(nibName: "SpecialOfferBannerViewController", bundle: nil)
            offerView.bannerId = result.id!
            self.navigationController?.pushViewController(offerView, animated: true)
        }
        //print(result)
    }
    
    
    @IBAction func didPressedMoreProductButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        var storyBoardId = String()
        storyBoardId = "SearchResultsTableViewController"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SearchResultsTableViewController
        nextViewControler.searchType = "product"
        self.navigationController?.pushViewController(nextViewControler, animated: false)
    }
    
    
    
    func getcategoryAPICall()  {
        
      
            startAnimating()
             let dictionary = ["Category": [:]]
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]) { (result : CategoryRootClass, error)  in
                DispatchQueue.main.async {
                    self.stopAnimating()
                    }
                if case .success = error {
                   let responsValue = result
                    if responsValue.Response[0].response_code == "1"{
                        self.tableViewData = (responsValue.Results)
                        DispatchQueue.main.async {
                           self.hotOffersCollectionView.reloadData()
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
    //TopSavers
    func getTopSaversAPICall() {
        
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
                            self.specialOfferTableview.reloadData()
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
    
    
  
    
    //MARK : =- GetDistrick API
    
    func getDistric(){
        
            startAnimating()
            let dictionary = ["District_List":[:]]
            
            api.fetchApiResult(viewController: self, paramDict: dictionary as! [String : [String : String]]){ (result: DistrickRootClass, error) in
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    
                    self.view.isUserInteractionEnabled = true
                }
                if case .success = error {
                    DispatchQueue.main.async {
                        let responsValue = result
                        
                        if responsValue.Response[0].response_code == "1"{
                            self.arrayDistric = [responsValue.Results[0]]
                            self.txtdropDown.text = "\(self.arrayDistric[0].district_name!)"
                            
                            self.txtdropDown.selectedRowColor = .yellow
                            self.txtdropDown.didSelect{(selectedText , index ,id) in
                                self.txtdropDown.text = selectedText
                            }
                            if self.arrayDistric.count > 1 {
                                self.txtdropDown.optionArray = self.arrayDistric.map({ $0.district_name })
                                self.txtdropDown.isUserInteractionEnabled = true
                              
                            }else {
                                self.txtdropDown.optionArray = []
                                self.txtdropDown.isUserInteractionEnabled = false
                               
                }
                            
                            
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


extension HomeViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == specialOfferTableview {
            return tableOffersViewData.count
        }else {
        return districkTableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == specialOfferTableview {
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
            
           // cell.imgProduct.af_setImage(withURL: URL(string: urlStr as String)!, placeholderImage: UIImage(named: appPlaceholerImage), filter: AspectScaledToFillSizeFilter(size: cell.imgProduct.frame.size))
            cell.imgProduct.af_setImage(withURL: URL(string: urlStr as String)!)
            
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
            
        }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celldistrick") as! DistrickTableViewCell
        cell.lblDistricname.text = districkTableData[indexPath.row].district_name!
        return cell
        }
        return UITableViewCell ()
    }
    
    
}

extension HomeViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        currentPage = page
       // print("current page:", page)
    }
}
public struct CheckVersionRootClass : Decodable {
    
    public var Data : CheckVersionData!
    public var Response : [CheckVersionResponse]!
    
}
public struct CheckVersionResponse : Decodable {
    
    public var response_code : String!
    public var response_msg : String!
    
}
public struct CheckVersionData  : Decodable {
    
    public var force_upgrade : String!
    public var latestversion : String!
    
}
