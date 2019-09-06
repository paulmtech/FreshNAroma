//
//  SearchResultsTableViewController.swift
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
class SearchResultsTableViewController: RootViewController,UITableViewDelegate,UITableViewDataSource ,ApiErrorResponsDelegate {
    func apiFailedResult(result: String) {
        self.stopAnimating()
        if result == Constants.apiReturnerror{
            let alertVc = UIAlertController(title:"", message:Constants.ALERT_SERVER_ERROR, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
     var searchResults = [SearchProductResult]() {
        didSet {
            setupTableViewBackgroundView()
             DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        tableView.tableFooterView = UIView()
        currentPage = "1"
        setupTableViewBackgroundView()
        if  searchType == SearchProduct.product.rawValue {
        setupSearchBar()
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.searchController.searchBar.becomeFirstResponder()
            }
       
        }else if  searchType == SearchProduct.special.rawValue {
         
        }
        
        LoadingView.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnBasket.badge = String(BasketData.badge)
    }
    private func setupTableViewBackgroundView() {
        
        
//       // let backgroundViewLabel = UILabel(frame: .zero)
//        if searchResults.count < 1 {
//            backgroundViewLabel.text = " Sorry! No record found. "
//        } else {
//            backgroundViewLabel.text = ""
//        }
//
//
//        backgroundViewLabel.textColor = .darkGray
//        backgroundViewLabel.numberOfLines = 0
//
//        backgroundViewLabel.textAlignment = NSTextAlignment.center
//        backgroundViewLabel.font.withSize(20)
//        tableView.backgroundView = backgroundViewLabel
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2",
                                                 for: indexPath) as! SearchProductTableViewCell
        
        cell.lblTitle.text = searchResults[indexPath.row].pdt_name

        return cell
    }
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
    let storyBoardId =  "SearchProductViewController"
    let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SearchProductViewController
    nextViewControler.searchText = searchResults[indexPath.row].pdt_name
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
}
extension SearchResultsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        currentPage = "1"
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            searchBarText = textToSearch
            fetchResults(for: textToSearch, page: currentPage)
        }
    }

    
    func fetchResults(for text: String , page: String) {
       
        LoadingView.isHidden = false
        
         let dictionary = ["ProductsAutoComplete": ["name":text]]
        
        apiFetcher.fetchApiResult(viewController: self, paramDict: dictionary) {
            (results : SearchProductRootClass, error ) in
            DispatchQueue.main.async {
            self.LoadingView.isHidden = true
            }
            if case .failure = error {
                return
            }
            let responsValue = results
           
            
            
            if responsValue.Response[0].response_code == "1"{
                let result = responsValue.Results
                self.searchResults.append(contentsOf: result! )
//            let pageInfo = results["PageInfo"].array!
//            self.currentPage = pageInfo[0]["currentpage"].string!
//            self.totalPage = pageInfo[0]["totalpage"].int!
//            self.totalrecords = pageInfo[0]["totalrecords"].int!
            }else {
                return
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults.removeAll()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let storyBoardId =  "SearchProductViewController"
        let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! SearchProductViewController
        nextViewControler.searchText = searchBar.text!
        self.navigationController?.pushViewController(nextViewControler, animated: true)
    }
}
