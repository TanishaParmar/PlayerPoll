//
//  DataManager.swift
//  PlayerPoll
//
//  Created by mac on 12/10/21.
//

import Alamofire
import Branch

struct SuccessModal<T>{
    var statusCode: Int
    var data: T
}

struct ErrorModal{
    var message: String
    var errorCode: Int
}

class DataManager{
    class func requestPOSTURL<T: Decodable>(type: T.Type, strURL : String, params : [String:Any], success:@escaping (_ response: T, _ statusCode: Int) -> Void, failure:@escaping (ErrorModal) -> Void){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: "Ok", handlerOK: nil)
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default,headers: ["Content-Type":"application/json"])
            .responseJSON { (response) in
                switch response.result{
                case .success(_):
                    let responseCode = response.response?.statusCode ?? -10
                    do{
                        if let data = response.data{
                            let successResponse = try JSONDecoder().decode(T.self, from: data)
                            success(successResponse, responseCode)
                        }else{
                            failure(ErrorModal(message: "Unable to parse response", errorCode: responseCode))
                        }
                    }catch{
                        failure(ErrorModal(message: error.localizedDescription, errorCode: 404))
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(ErrorModal(message: error.localizedDescription, errorCode: error.code))
                }
            }
    }
    
    
    class func requestPOSTURLWithHeaders<T: Decodable>(type: T.Type, strURL : String, params : Parameters,headers: HTTPHeaders, encoding: ParameterEncoding, success:@escaping (_ response: T, _ statusCode: Int) -> Void, failure:@escaping (ErrorModal) -> Void){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: "Ok", handlerOK: nil)
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { (response) in
                switch response.result{
                case .success(let json):
                    let responseCode = response.response?.statusCode ?? -10
                    do{
                        print(response.result, json)
                        if let data = response.data{
                            let successResponse = try JSONDecoder().decode(T.self, from: data)
                            success(successResponse, responseCode)
                        }else{
                            failure(ErrorModal(message: "Unable to parse response", errorCode: responseCode))
                        }
                    }catch{
                        failure(ErrorModal(message: error.localizedDescription, errorCode: 404))
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(ErrorModal(message: error.localizedDescription, errorCode: error.code))
                }
            }
    }
    
    
    
    class func requestPOSTWithFormData<T: Decodable>(type: T.Type, strURL : String, params : [String : AnyObject]?, headers: HTTPHeaders,imageData:[[String:Any]], success:@escaping (_ response: T, _ statusCode: Int) -> Void, failure:@escaping (ErrorModal) -> Void) {
        DispatchQueue.main.async {
            if !Reachability.isConnectedToNetwork(){
                DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: "Ok", handlerOK: nil)
                return
            }
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.upload(multipartFormData: { (multipartData) in
            for (key, value) in params!{
                multipartData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            if imageData.count > 0{
                for obj in imageData{
                    let name = obj["param"] as? String ?? ""
                    let data = obj["imageData"] as? Data ?? Data()
                    multipartData.append(data, withName: name, fileName: randomString(length: 6)+".jpg", mimeType: "image/jpeg")
                }
            }
        }, to: urlwithPercentEscapes!, method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(_):
                let responseCode = response.response?.statusCode ?? -10
                do{
                    if let data = response.data{
                        let successResponse = try JSONDecoder().decode(T.self, from: data)
                        success(successResponse, responseCode)
                    }else{
                        failure(ErrorModal(message: "Unable to parse response", errorCode: responseCode))
                    }
                }catch{
                    failure(ErrorModal(message: error.localizedDescription, errorCode: responseCode))
                    print("parsing error", error.localizedDescription)
                }
            case .failure(let error):
                let error : NSError = error as NSError
                failure(ErrorModal(message: error.localizedDescription, errorCode: error.code))
                print(error.localizedDescription)
            }
        })
    }
    
    class func requestPOSTWithFormDataa(_ strURL : String, params : [String : AnyObject]?, headers: HTTPHeaders,imageData:[[String:Any]], success:@escaping (SuccessModall) -> Void, failure:@escaping (ErrorModal) -> Void) {
        if !Reachability.isConnectedToNetwork(){
            HUD.hideHud()
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: "Ok", handlerOK: nil)
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.upload(multipartFormData: { (multipartData) in
            for (key, value) in params!{
                multipartData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            if imageData.count > 0{
                for obj in imageData{
                    let name = obj["param"] as? String ?? ""
                    let data = obj["imageData"] as? Data ?? Data()
                    multipartData.append(data, withName: name, fileName: randomString(length: 6)+".jpg", mimeType: "image/jpeg")
                }
            }
        }, to: urlwithPercentEscapes!, method: .post, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(let json):
                if let responseJson = json as? NSDictionary{
                    let responseCode = response.response?.statusCode ?? -10
                    success(SuccessModall(statusCode: responseCode, data: responseJson))
                }
                print(json)
            case .failure(let error):
                let error : NSError = error as NSError
                failure(ErrorModal(message: error.localizedDescription, errorCode: error.code))
                print(error.localizedDescription)
            }
        })
    }
    
    class func requestGETURL<T: Decodable>(type: T.Type, strURL : String, headers: HTTPHeaders,encoding: ParameterEncoding, success:@escaping (_ response: T, _ statusCode: Int) -> Void, failure:@escaping (ErrorModal) -> Void){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: "Ok", handlerOK: nil)
            return
        }
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get, encoding: encoding, headers: headers)
            .responseJSON { (response) in
                switch response.result{
                case .success(_):
                    let responseCode = response.response?.statusCode ?? -10
                    do{
                        if let data = response.data{
                            let successResponse = try JSONDecoder().decode(T.self, from: data)
                            success(successResponse, responseCode)
                        }else{
                            failure(ErrorModal(message: "Unable to parse response", errorCode: responseCode))
                        }
                    }catch{
                        failure(ErrorModal(message: error.localizedDescription, errorCode: 404))
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(ErrorModal(message: error.localizedDescription, errorCode: error.code))
                }
            }
    }
    
    class func presentShare(objectsToShare: [Any], vc: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = vc.view
        activityVC.popoverPresentationController?.sourceRect = vc.view.frame
        vc.present(activityVC, animated: true, completion: nil)
    }
    
    class func showImagePicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate, vc: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.navigationController?.transparent()
            imagePicker.navigationBar.tintColor = .black
            imagePicker.navigationBar.barStyle = .black
            
            vc.present(imagePicker, animated: true, completion:nil)
            imagePicker.delegate = delegate
        } else {
            DisplayAlertManager.shared.displayAlert(animated: true, message: "You denied permissions to access your photos. You'll need to allow permissions to choose photos to post.", okTitle: "OK", handlerOK: nil)
        }
    }
    
    class func getCategories(completion: @escaping(([CategoryData])->Void), failure: @escaping(()->Void)){
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getAllCategory)
        HUD.showHud()
        DataManager.requestPOSTWithFormData(type: CategoryDataResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            HUD.hideHud()
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if let cats = responseData.data{
                completion(cats)
            }else{
                failure()
            }
        } failure: { error in
            HUD.hideHud()
            print(error)
            failure()
        }
    }
    
//    class func createContentDeepLink(title: String,type: String,OtherId: String, description: String, image: String?,link: String,completion: @escaping (String?) -> ()) {
//        let buo = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
//        buo.canonicalUrl = "http://mobile.restoredglory.org/RestoredGloryChristianCenter/"
//        buo.publiclyIndex = false
//        buo.locallyIndex = false
//        buo.title = title
//        buo.contentDescription = description
//        if image != "" {
//            buo.imageUrl = image
//        }
//        let linkLP: BranchLinkProperties =  BranchLinkProperties()
//        linkLP.addControlParam("link", withValue: link)
//        linkLP.addControlParam("OtherID", withValue: OtherId)
//        linkLP.addControlParam("type", withValue: type)
//        linkLP.addControlParam("environment", withValue: DataManager.returnEnv().rawValue)
//        buo.getShortUrl(with: linkLP) { (url, error) in
//            if error == nil {
//                completion(url)
//            }
//        }
//        print(linkLP)
//    }
    
    class func createContentDeepLink(title: String,type: String,OtherId: String,completion: @escaping (String?) -> ()) {
        let buo = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        buo.canonicalUrl = "playerpoll://" //"https://www.playerpoll.com"
        buo.publiclyIndex = false
        buo.locallyIndex = false
        buo.title = title
//        buo.imageUrl
//        buo.contentDescription = description
//        if image != "" {
//            buo.imageUrl = image
//        }
        let linkLP: BranchLinkProperties =  BranchLinkProperties()
//        linkLP.addControlParam("link", withValue: link)
        linkLP.addControlParam("OtherID", withValue: OtherId)
//        linkLP.addControlParam("type", withValue: type)
        linkLP.addControlParam("environment", withValue: DataManager.returnEnv().rawValue)
        buo.getShortUrl(with: linkLP) { (url, error) in
//            print(url)
//            print(error)
            if error == nil {
                completion(url)
            }
        }
        print(linkLP)
    }
    
    class func returnEnv()->Env{
        return Constant.appBaseUrl == "playerpoll://" ? .prod : .dev
    }
   
    
}

struct SuccessModall{
    var statusCode: Int
    var data: NSDictionary
}

enum Env:String{
    case dev
    case prod
}
