//
//  SubCategoryViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 21/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit


    class SubCategoryViewController: RootViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SubMenuListDelegate {
        var categoryId = String()
        var navigationTitle = String()
      //  var actionFrom = String()
        var actionDictionary = [String: AnyObject]()
        func didAddButtonTapped(btn: UIButton) {
            
        }
        
        func didMinusButtonTapped(btn: UIButton) {
            
        }
         @IBOutlet var viewNoResult: UIView!
        var tableViewData = [subcategoryResult]()
        
        @IBOutlet weak var collectionView: UICollectionView!
        override func viewDidLoad() {
            super.viewDidLoad()
            
            lblNavigationTitle.text = navigationTitle
            categoryId = categoryId == "" ? "5" : categoryId
            getsubcategoryAPICall()
            self.viewNoResult.isHidden = true
            
           
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            btnBasket.badge = String(BasketData.badge)
        }
        func getsubcategoryAPICall()  {
            
            if  Connectivityy.isConnectedToInternet{
                startAnimating()
                let longstring = authParameter()!
                
            let jsonData = try? JSONSerialization.data(withJSONObject: actionDictionary, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
               
                let plainData1: Data? = jsonString!.data(using: .utf8)
                let digest2 = plainData1?.base64EncodedString(options: [])
                let qry = "Case=\(digest2 ?? "")"
                let jsonUrlString = "\(baseUrl)\(longstring)&\(String(describing: qry))"
                guard let url = URL(string: jsonUrlString) else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                     self.stopAnimating()
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    do{
                        
                        let responsValue = try JSONDecoder().decode(subcategoryRootClass.self, from: data)
                      
                        
                        if responsValue.Response[0].response_msg == "Success"{
                            
                            self.tableViewData = (responsValue.Results)
                            DispatchQueue.main.async {
                                self.chekTabledate()
                                self.collectionView.reloadData()
                            }
                            
                            
                            
                        }else  if responsValue.Response[0].response_code == "0"{
                            self.chekTabledate()
                        }
                        
                    } catch {
                        
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
            
            if tableViewData.count <= 0 {
                DispatchQueue.main.async {
                    self.viewNoResult.isHidden = false
                }
                
            }else {
                DispatchQueue.main.async {
                    self.viewNoResult.isHidden = true
                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return tableViewData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffercollectionCell", for: indexPath) as! OfferCollectionViewCell
            //cell.bgView.layer.cornerRadius = 5
            cell.bgView.layer.borderWidth = 1
            cell.bgView.layer.borderColor = UIColor.hexStringToUIColor(hex: ColorCode.yellow.rawValue, alphavalue: 1.0) .cgColor
            let  cellData = tableViewData[indexPath.row]
            cell.lblTitle?.text = cellData.sub_category
            cell.imageView.image = UIImage(named:  "SideMenuProfile")
            //        cell.lblPrice.text = cellData["price"] as? String
            //        cell.lblDiscription.text = cellData["discription"] as? String
            
            return cell
            
            
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
           
            let storyBoardId =  "SubCategoryProductsViewController"
            
            let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SubCategoryProductsViewController
            let  cellData = tableViewData[indexPath.row]
            nextViewControler.categoryId = cellData.sub_category
             nextViewControler.navigationTitle = cellData.sub_category
            self.navigationController?.pushViewController(nextViewControler, animated: true)
            
        }
        
        
        
        //  MARK: UICollectionViewDelegateFlowLayout methods
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let totalwidth = collectionView.bounds.size.width;
            let numberOfCellsPerRow = 2
            
            //let oddEven = indexPath.row / numberOfCellsPerRow % 2
            let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
            
            return CGSize(width: dimensions, height: 160)
            
            
            
        }
        //        func collectionView(_ collectionView: UICollectionView, layout
        //            collectionViewLayout: UICollectionViewLayout,
        //                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //            //return 2.0
        //
        //        }
}
