//
//  OfferCollectionViewController.swift
//  FreshNAroma
//
//  Created by Kavitha Jagannathan on 07/09/18.
//  Copyright © 2018 CMC GROUP OF INSTITUTIONS. All rights reserved.
//

import UIKit

class OfferCollectionViewController: RootViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SubMenuListDelegate {
    func didAddButtonTapped(btn: UIButton) {
        
    }
    
    func didMinusButtonTapped(btn: UIButton) {
        
    }
    
     var tableViewData = [[String : Any]]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
     tableViewData = [["title" : "Item" , "image" : "1","price" : "₹10" ,"discription" : "Item discrition" ],["title" : "Profile" , "image" : "2","price" : "₹10" ,"discription" : "Item discrition"],["title" : "My Orders" , "image" : "3","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Categories" , "image" : "1","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Offers" , "image" : "2","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Fresh Cash" , "image" : "3","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Logout" , "image" : "1","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Item" , "image" : "1","price" : "₹10" ,"discription" : "Item discrition" ],["title" : "Profile" , "image" : "2","price" : "₹10" ,"discription" : "Item discrition"],["title" : "My Orders" , "image" : "3","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Categories" , "image" : "1","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Offers" , "image" : "2","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Fresh Cash" , "image" : "3","price" : "₹10" ,"discription" : "Item discrition"],["title" : "Logout" , "image" : "1","price" : "₹10" ,"discription" : "Item discrition"]]
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.lblTitle?.text = cellData["title"] as? String
        cell.imageView.image = UIImage(named: cellData["image"]! as! String)
        cell.lblPrice.text = cellData["price"] as? String
        cell.lblDiscription.text = cellData["discription"] as? String
        
            return cell
      
        
       
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
           
            let storyBoardId =  "HotOfferDetailViewController"
            
            let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId)
            self.navigationController?.pushViewController(nextViewControler, animated: true)
       
}

   
   
   //  MARK: UICollectionViewDelegateFlowLayout methods
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let totalwidth = collectionView.bounds.size.width;
            let numberOfCellsPerRow = 2
    
            //let oddEven = indexPath.row / numberOfCellsPerRow % 2
            let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
   
                return CGSize(width: dimensions, height: 213)
    
    
           
        }
//        func collectionView(_ collectionView: UICollectionView, layout
//            collectionViewLayout: UICollectionViewLayout,
//                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            //return 2.0
//
//        }
}
