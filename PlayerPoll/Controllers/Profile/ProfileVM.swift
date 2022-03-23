//
//  ProfileVM.swift
//  PlayerPoll
//
//  Created by mac on 30/11/21.
//

import Foundation
import Alamofire


class ProfileVM{
    
    var delegate:ProgressHUDProtocol?
    var details:Observable<UserProfile?> = Observable(nil)
    var polls:Observable<[HomePolls]> = Observable([])
    var flagDetails:Observable<FlagDetails?> = Observable(nil)
    var id: String
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol, id: String) {
        self.delegate = delegate
        self.id = id
    }
    
    
    func loadProfileData(){
        let profileOperation = BlockOperation { [weak self] in
            self?.getProfileData()
        }
        
        let pollsOperation = BlockOperation { [weak self] in
            self?.getAllPolls()
        }
        
        pollsOperation.addDependency(profileOperation)
        
        let oQ = OperationQueue()
        oQ.qualityOfService = .utility
        oQ.addOperations([profileOperation,pollsOperation], waitUntilFinished: false)
    }
    
    //MARK:- Service Call Method(s)
    func getProfileData() {
        let params = ["userID":id] as [String:AnyObject]
        let url = getFinalUrl(with: .getProfileById)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: UserProfileResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
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

    func getAllPolls(catId: String = "0") {
        let params = ["authToken":Globals.authToken,"userID":id,"type":"1","catID":catId,"perPage":"100","pageNo":"\(1)"] as [String:AnyObject]
        let url = getFinalUrl(with: .getUserPolls)
        self.delegate?.showHideHUD(showVal: true)
        self.polls.value = []
        DataManager.requestPOSTWithFormData(type: HomeResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.polls.value = responseData.data ?? []
            self.delegate?.showHideHUD(showVal: false)
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

