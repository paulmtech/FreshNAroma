//
//  CategoryViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 05/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
class CategoryViewController: RootViewController,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    var tableViewData = [CategoryResult]()
     @IBOutlet var viewNoResult: UIView!
    @IBOutlet weak var categoryTableView: UITableView!{
        didSet{
            categoryTableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoResult.isHidden = true
        getcategoryAPICall()
        api.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            self.chekTabledate()
                            self.categoryTableView.reloadData()
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

}
extension CategoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCellTableViewCell
       
        let  cellData = tableViewData[indexPath.row]
        cell.lblItemName?.text = cellData.category
        let url = URL(string: cellData.categoryimage)
        let placeholder = UIImage(named: appPlaceholerImage)
        let filter = AspectScaledToFillSizeFilter(size: cell.itemImage.frame.size)
        cell.itemImage.af_setImage(withURL: url!, placeholderImage: placeholder, filter: filter)
        

      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
      
        let storyBoardId =  "SubCategoryViewController"
        let  cellData = tableViewData[indexPath.row]
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SubCategoryViewController
        let actionDict =  ["Subcategory": ["category":"\(cellData.id!)"]] as [String : AnyObject]
        nextViewControler.actionDictionary = actionDict
        nextViewControler.navigationTitle = cellData.category
        self.navigationController?.pushViewController(nextViewControler, animated: true)
    }
}

