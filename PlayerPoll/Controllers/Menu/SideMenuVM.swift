//
//  SideMenuVM.swift
//  PlayerPoll
//
//  Created by mac on 15/11/21.
//

import Foundation
import Alamofire


class SideMenuVM{
    
    var delegate:ProgressHUDProtocol?
    
    var details:Observable<Profile?> = Observable(nil)
    
    var unReadNotifications: Observable<Bool> = Observable(false)
    
    var flagDetails:Observable<FlagDetails?> = Observable(nil)

    
    var options:Observable<[SideMenuOptions]> = Observable([.notifications, .leaderboard, .listview, .messages, .rewards, .settings, .contact])
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
        getUnreadMessageCount()
    }
    
    
    func getProfileData() {
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getProfile)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            print("data is =>",data)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            if let userData = data.data {
                self.getFlagDetails(countryCode: userData.countryCode)
                self.details.value = userData
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    func getRewardsStatus(completion: @escaping((Bool)->Void)){
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getProfile)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            if let userData = data.data {
                completion(userData.diamondPoints.toIntVal() > 10000)
            }else{
                completion(false)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            completion(false)
        }
    }
    
    
    
    func getUnreadMessageCount(){
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getUnreadTotalMessageCount)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: MessageUnreadResponse.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            self.unReadNotifications.value = data.count.toIntVal() != 0
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
        }
    }
    
    func addSuperAdmin(){
        if let firstIndex = self.options.value.firstIndex(where: {$0 == .contact}){
            self.options.value.remove(at: firstIndex)
        }
        let empty = self.options.value.filter({$0 == .superadmin}).isEmpty
        if empty{
            self.options.value.append(.superadmin)
        }
    }
    
    func checkForContact(){
        guard self.options.value.filter({$0 == .contact}).isEmpty else {
            return
        }
        self.options.value = [.notifications, .leaderboard, .listview, .messages, .rewards, .settings, .contact]
    }
    
    func getFlagDetails(countryCode: String){
        Globals().getCountryData { flags in
            self.flagDetails.value = flags.filter({$0.countryCode == countryCode}).first
        }
    }
}

