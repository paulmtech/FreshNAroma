import Foundation
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
enum NetworkError: Error {
    case failure
    case success
    case nodata
}

protocol ApiErrorResponsDelegate {
    func apiFailedResult(result : String)
}
//Local
//public let baseUrl = "http://192.168.1.101/fresh/controlpanel/Scripts/V1/web_service.php?"
//live
public let baseUrl = "https://www.freshnaroma.com/controlpanel/Scripts/V1/web_service.php?"
let sessionId = UIDevice.current.identifierForVendor?.uuidString

class Connectivityy {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
public func authParameter() -> String? {
    var AuthString: String
    let timestamp1 = Int(Date().timeIntervalSince1970)
    let timeStampString = "\(timestamp1)"
    let _interval = TimeInterval(Double(timeStampString) ?? 0.0) //convert str into
    let date = Date(timeIntervalSince1970: _interval) //convert the double value to
    let df = DateFormatter() //format the date as we needed type
    df.dateFormat = "yyyy-MM-dd hh:mm:ss" //initialize date format
    let originalDate = df.string(from: date)
    let pass = "aciosuser\(originalDate)"
    let plainData: Data? = pass.data(using: .utf8)
    let digest1 = plainData?.base64EncodedString(options: [])
    let uid = "ac_ios_user"
    let jjj = "{\"digest\":\"\(String(describing: digest1))\",\"username\":\"\(uid)\",\"timestamp\":\"\(originalDate)\"}"
    let jsonS = "{\"auth\":\(jjj)}"
    let plainData1: Data? = jsonS.data(using: .utf8)
    let digest2 = plainData1?.base64EncodedString(options: [])
    let qry = "Auth=\(digest2 ?? "")"
    AuthString = qry
    return AuthString
}

class APIRequestFetcher : NVActivityIndicatorViewable {
    
    var delegate: ApiErrorResponsDelegate?
    func constructUrl(dict: [String : Any]) -> String {
        let authString = authParameter()!
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        let plainData1: Data? = jsonString!.data(using: .utf8)
        let digest2 = plainData1?.base64EncodedString(options: [])
        let qry = "Case=\(digest2 ?? "")"
        let urlString = "\(baseUrl)\(authString)&\(String(describing: qry))"
        return urlString
    }
    
    
    
    
    func searchProduct(searchText: String,searchPage: String ,completionHandler: @escaping (JSON?, NetworkError) -> ()) {
       
       let dictionary = ["SearchProducts": ["type":"product","name":searchText,"page":searchPage]]
        let urlToSearch = constructUrl(dict: dictionary)
        
        Alamofire.request(urlToSearch).responseJSON { response in
            guard let data = response.data else {
                
                
                completionHandler(["error" : "error" as AnyObject],.failure)
                return
            }
            
            let json = try? JSON(data: data)
            let results = json
            guard let empty = results?.isEmpty, !empty else {
               completionHandler(["error" : "error" as AnyObject],.failure)
                return
            }
            completionHandler(["result" : results as AnyObject],.success)
        }
        
        
    }
    
    
    
    //    Generics Method get Request
func fetchApiResult<T: Decodable>(viewController : UIViewController,paramDict : [String: [String : String]],completionHandler: @escaping (T,NetworkError) -> ()) {
    
        if  Connectivityy.isConnectedToInternet{
            let jsonUrlString = constructUrl(dict: paramDict)
            guard let url = URL(string: jsonUrlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                do{
                    let responsValue = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(responsValue,.success)
                } catch {
                    self.delegate?.apiFailedResult(result: Constants.apiReturnerror)
                   return
                }
            }
            task.resume()
        }else{
            self.delegate?.apiFailedResult(result: Constants.apiNoInternet)
            noInternetAlert(viewController: viewController, alertType: "image")
        }
    }
    
    //    Mark: - PosT Method
    func getOffers(userinfo :[String : String],viewController : UIViewController,completionHandler: @escaping ([String: AnyObject],NetworkError) -> ()){
        if  Connectivityy.isConnectedToInternet{
            let jsonUrlString = constructUrl(dict: userinfo)
            guard let url = URL(string: jsonUrlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache",
            ]
            request.allHTTPHeaderFields = headers
            let jsonData = try? JSONSerialization.data(withJSONObject: userinfo)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do{
                    let responsValue = try JSONDecoder().decode(OffersRootClass.self, from: data)
                    
                    completionHandler(["result" : responsValue as AnyObject],.success)
                    
                } catch let jsonErr {
                    
                    
                    completionHandler(["error": jsonErr.localizedDescription as AnyObject],.failure)
                }
            }
            task.resume()
        }else{
            noInternetAlert(viewController: viewController, alertType: "text")
        }
    }
    
    func updateUserProfile(userinfo :[String : String],viewController : UIViewController,completionHandler: @escaping ([String: AnyObject],NetworkError) -> ()){
        if  Connectivityy.isConnectedToInternet{
            
            let dictionary: [String : Any] = [
                "MyProfileUpdate": userinfo]
            let jsonUrlString = constructUrl(dict: dictionary)
            
            guard let url = URL(string: jsonUrlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache",
            ]
            request.allHTTPHeaderFields = headers
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary)
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do{
                    let responsValue = try JSONDecoder().decode(UserprofileUpdateRootClass.self, from: data)
                    
                    completionHandler(["result" : responsValue as AnyObject],.success)
                    
                } catch let jsonErr {
                    
                    
                    completionHandler(["error":jsonErr.localizedDescription as AnyObject],.failure)
                }
            }
            task.resume()
        }else{
            noInternetAlert(viewController: viewController, alertType: "text")
        }
    }
    
    func userRegistration(userinfo :[String : String],viewController : UIViewController,completionHandler: @escaping ([String: AnyObject],NetworkError) -> ()){
        if  Connectivityy.isConnectedToInternet{
            
            let fname = userinfo["first_name"]!
            let lname = userinfo["last_name"]!
            let contact = userinfo["contact"]!
            let email = userinfo["email_address"]!
            let otp = userinfo["otp"]!
            let ref_level = userinfo["ref_level1"] ?? ""
            
            let dictionary  = ["Register": ["first_name":fname,"last_name":lname,"contact":contact,"email_address":email,"otp":otp,"ref_level1": ref_level, "user_mode": "iOS"]]
            let jsonUrlString = constructUrl(dict: dictionary)
            guard let url = URL(string: jsonUrlString) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache",
            ]
            request.allHTTPHeaderFields = headers
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do{
                    let responsValue = try JSONDecoder().decode(otpRootClass.self, from: data)
                    
                    completionHandler(["result" : responsValue as AnyObject],.success)
                    
                } catch let jsonErr {
                    completionHandler(["error": jsonErr.localizedDescription as AnyObject],.failure)
                }
            }
            task.resume()
        }else{
            noInternetAlert(viewController: viewController, alertType: "text")
        }
    }
    //Mark: - internet check
    func noInternetAlert(viewController : UIViewController, alertType: String){
        if alertType == "image"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
            let storyBoardId = "nonetwork"
            let nextViewControler = storyBoard.instantiateViewController(withIdentifier: storyBoardId) as! NoNetWorkViewController
            viewController.present(nextViewControler, animated:false, completion: nil)
        }else {
            let alert = UIAlertController(title: "FreshNAroma", message: Constants.ALERT_NETWORK_ERROR, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}




