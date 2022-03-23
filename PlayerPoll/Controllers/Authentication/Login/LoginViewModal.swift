//
//  LoginManager.swift
//  PlayerPoll
//
//  Created by mac on 01/11/21.
//

import Alamofire
import FBSDKLoginKit


protocol LoginViewModalProtocol {
    func showHideHUD(showVal: Bool)
    func navigateForward(with val: Bool)
    func showErrorMessage(message: String)
}

class LoginViewModal{
                
    var delegate: LoginViewModalProtocol?
//    var delegateRegister:RegisterViewModalProtocol?

    let fbLoginManager = LoginManager()

    var rememberMe:Observable<Bool> = Observable(false)
    
    var storedCredentials: Observable<(String,String)> = Observable(("",""))
    
    init(delegate: LoginViewModalProtocol) {
        self.delegate = delegate
        storedCredentials.value = Globals.getStoredEmailPwd()
        if !storedCredentials.value.0.isEmpty && !storedCredentials.value.1.isEmpty{
            self.rememberMe.value = true
        }
    }
    
//    init(delegate: RegisterViewModalProtocol) {
//        self.delegateRegister = delegate
//        fbLoginManager = LoginManager()
//    }
    
    
    func loginTapped(with email: String, password: String) {
        if email.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterEmailUName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if password.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPassword, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        hitLoginApi(with: email, password: password)
    }
    
    //Apple SignIn
    func appleLogin(with email: String, userName: String,appleToken: String, appleImage: String){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .appleLogin)
        let params = ["email":email,"userName":userName,"deviceToken":Globals.deviceToken,"deviceType":"1","appleToken":appleToken,"appleImage":appleImage] as [String:AnyObject]
        DataManager.requestPOSTWithFormData(type: LoginResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if let data = response.data, response.status == 200{
                print(data)
                UserDefaults.standard.setValue(data.authToken, forKey: DefaultKeys.authToken)
                UserDefaults.standard.setValue(data.userID, forKey: DefaultKeys.id)
                UserDefaults.standard.setValue(data.userRole, forKey: DefaultKeys.role)
                UserDefaults.standard.set(data.profileComplete == "1", forKey: DefaultKeys.detailsSubmitted)
                self.delegate?.navigateForward(with: data.profileComplete == "1")
            }else{
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }
    }
    
    //Facebook Login
    func loginWithFacebook(vc: UIViewController){
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["public_profile","email","user_gender"], from: vc) { (result, error) in
            guard error == nil else{
                DisplayAlertManager.shared.displayAlert(animated: true, message: error?.localizedDescription ?? "", okTitle: "Ok", handlerOK: nil)
                return
            }
            let width = 400
            let height = 400
            if((AccessToken.current) != nil){
                self.delegate?.showHideHUD(showVal: true)
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.width(\(width)).height(\(height)), email, gender, birthday"]).start(completionHandler: { [weak self](connection, result, errror) -> Void in
                    guard let strongSelf = self else {return}
                    strongSelf.delegate?.showHideHUD(showVal: false)
                    if (error == nil) {
                        let dict = result as! [String:Any]
                        let name = dict["name"] as? String ?? ""
                        let fbId = dict["id"] as? String ?? ""
                        let emailID = dict["email"] as? String ?? ""
                        let imageUrl = ((dict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String ?? ""
                        print(fbId, name, emailID,imageUrl)
                        //Facebook login server call
                        strongSelf.facebookLogin(with: emailID, userName: name, facebookToken: fbId, facebookImage: imageUrl)
                    }else{
                        strongSelf.delegate?.showErrorMessage(message: error?.localizedDescription ?? "")
                    }
                })
            }
        }
    }
    
    //facebook SignIn
    func facebookLogin(with email: String, userName: String,facebookToken: String, facebookImage: String){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .facebookLogin)
        let params = ["email":email,"userName":userName,"deviceToken":Globals.deviceToken,"deviceType":"1","facebookToken":facebookToken,"facebookImage":facebookImage] as [String:AnyObject]
        DataManager.requestPOSTWithFormData(type: LoginResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if let data = response.data, response.status == 200{
                print(data)
                UserDefaults.standard.setValue(data.authToken, forKey: DefaultKeys.authToken)
                UserDefaults.standard.setValue(data.userID, forKey: DefaultKeys.id)
                UserDefaults.standard.setValue(data.userRole, forKey: DefaultKeys.role)
                UserDefaults.standard.set(data.profileComplete == "1", forKey: DefaultKeys.detailsSubmitted)
                self.delegate?.navigateForward(with: data.profileComplete == "1")
            }else{
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }
    }
    
    func hitLoginApi(with email: String, password: String){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .login)
        let params = ["email":email,"password":password,"deviceToken":Globals.deviceToken,"deviceType":"1"] as [String:AnyObject]
        DataManager.requestPOSTWithFormData(type: LoginResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if let data = response.data, response.status == 200 {
                print(data)
                UserDefaults.standard.setValue(data.authToken, forKey: DefaultKeys.authToken)
                UserDefaults.standard.setValue(data.userID, forKey: DefaultKeys.id)
                UserDefaults.standard.setValue(data.userRole, forKey: DefaultKeys.role)
                UserDefaults.standard.set(data.profileComplete == "1", forKey: DefaultKeys.detailsSubmitted)
                if self.rememberMe.value {
                    UserDefaults.standard.setValue(email, forKey: DefaultKeys.storedEmail)
                    UserDefaults.standard.setValue(password, forKey: DefaultKeys.storedPwd)
                } else {
                    UserDefaults.standard.removeObject(forKey: DefaultKeys.storedEmail)
                    UserDefaults.standard.removeObject(forKey: DefaultKeys.storedPwd)
                }
                self.delegate?.navigateForward(with: data.profileComplete == "1")
            }else{
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }
    }
    
}
