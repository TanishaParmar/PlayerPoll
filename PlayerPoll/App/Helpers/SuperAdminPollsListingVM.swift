//
//  SuperAdminPollsListingVM.swift
//  PlayerPoll
//
//  Created by mac on 18/11/21.
//

import Foundation
import Alamofire


class SuperAdminPollsListingVM{
    
    var delegate:ProgressHUDProtocol?
    
    var polls:Observable<[SuperAdminPolls]> = Observable([])
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Service Call Method(s)
    func getAllPolls() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .superAdminPolls)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: SuperAdminPollsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.polls.value = responseData.data.sorted(by: {$0.getCreationDate() > $1.getCreationDate()})
            self.delegate?.showHideHUD(showVal: false)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
}

