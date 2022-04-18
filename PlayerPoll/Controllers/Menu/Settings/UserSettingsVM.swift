//
//  SettingViewModel.swift
//  PlayerPoll
//
//  Created by MyMac on 11/9/21.
//

import Foundation
import Alamofire

class UserSettingsVM {
    var delegate:ProgressHUDProtocol?
    var details:Observable<Profile?> = Observable(nil)
    var logoutConfirmedVal: Observable<Bool> = Observable(false)
    var flagDetails:Observable<FlagDetails?> = Observable(nil)
    var imageEdited = false
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Validation Method(s)
    func saveTapped(with userName: String, data: Data?, notificationState: String){
        
        if userName.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterUserName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        guard let flag = self.flagDetails.value else {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectCountry, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        hitEditProfileApi(userName: userName, notificationState: notificationState, profileImage: data, countryCode: flag.countryCode)
    }
    
    
    //MARK:- Service Call Method(s)
    func getProfileData() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getProfile)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            print("data is =>",data)
            if statusCode == 401 {
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            if let userData = data.data {
                self.details.value = userData
                self.getFlagDetails(countryCode: userData.countryCode)
            }
        } failure: { error in
            print(error)
            self.delegate?.showHideHUD(showVal: false)
        }
    }
    
    
    func askForLogoutConfirmation(){
        self.logoutConfirmedVal.value = true
    }
    
    func logoutTapped(){
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .logout)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            print("data is =>",data)
            self.delegate?.showHideHUD(showVal: false)
            appDelegate().setLogoutScreen()
            return
        } failure: { error in
            print(error)
            self.delegate?.showHideHUD(showVal: false)
        }
    }
    
    func hitEditProfileApi(userName: String, notificationState: String, profileImage: Data?, countryCode: String) {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken, "userName": userName, "notificationDisable": notificationState,"countryCode":countryCode] as [String:AnyObject]
        let url = getFinalUrl(with: .editProfile)
        var imagArray = [[String:Any]]()
        if let img = profileImage {
            imagArray.append(["param":"profileImage","imageData":img])
        }
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: imagArray) { response, statusCode in
            print("response is =>",response)
            self.delegate?.showHideHUD(showVal: false)
            if statusCode == 200 {
                DisplayAlertManager.shared.displayAlert(animated: true, message: response.message, okTitle: "OK", handlerOK: nil)

            }
            if let userProfileData = response.data {
                self.details.value = userProfileData
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    
    func getFlagDetails(countryCode: String){
        Globals().getCountryData { flags in
            self.flagDetails.value = flags.filter({$0.countryCode == countryCode}).first
        }
    }
    
}

