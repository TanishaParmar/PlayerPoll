//
//  RegisterVM.swift
//  PlayerPoll
//
//  Created by mac on 02/11/21.
//

import Foundation
import Alamofire
import FBSDKLoginKit
protocol RegisterViewModalProtocol {
    func showHideHUD(showVal: Bool)
    func showErrorMessage(message: String)
    func navigateForward(with val: Bool)
}

class RegisterViewModal{
    
    var delegate:RegisterViewModalProtocol?
    let fbLoginManager:LoginManager!
    var agreeTerms:Observable<Bool> = Observable(false)

    var pickedImage:Observable<Bool> = Observable(false)
    var flagDetails:Observable<FlagDetails?> = Observable(nil)
    //MARK:- (D.E.) Dependency Injection
    init(delegate: RegisterViewModalProtocol) {
        self.delegate = delegate
        fbLoginManager = LoginManager()
    }
    
    
    func setForFailedPic(){
        if !pickedImage.value{
            pickedImage.value = false
        }
    }
    
    
    func signUpTapped(with email: String, userName: String, password: String, data: Data?){
        if email.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterEmail, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if !ValidationManager.shared.isValid(text: email, for: .email){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterValidEmail, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if userName.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterUserName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if password.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPassword, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if !agreeTerms.value{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kAgreeTerms, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if !pickedImage.value{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kPickProfilePicture, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        guard let flag = self.flagDetails.value else {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectCountry, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        print("anni aipoyay")
        hitSignUpApi(with: email, password: password, userName: userName, data: data, countryCode: flag.countryCode)
    }
    
    
    
    func hitSignUpApi(with email: String, password: String, userName: String, data: Data?, countryCode: String){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .signUp)
        let params = ["email":email,"password":password,"deviceToken":Globals.deviceToken,"deviceType":"1","userName":userName,"countryCode":countryCode] as [String:AnyObject]
        var imagArray = [[String:Any]]()
        if let imageData = data{
            imagArray.append(["param":"profileImage","imageData":imageData])
        }
        DataManager.requestPOSTWithFormData(type: RegisterResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: imagArray) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if let data = response.data, response.status == 200{
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
//                        strongSelf.performSocialLogin(email: emailID, name: name, gid: "", fid: fbId, aid: "", imageUrl: imageUrl, type: .facebook)
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
    
}




