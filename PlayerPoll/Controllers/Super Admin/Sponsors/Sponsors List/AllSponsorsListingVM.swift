//
//  AllSponsorsListingVM.swift
//  PlayerPoll
//
//  Created by mac on 17/11/21.
//

import Foundation
import Alamofire


class AllSponsorsListingVM{
    
    var delegate:ProgressHUDProtocol?
    var sponsors: Observable<[Sponsors]> = Observable([])

    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Service Call Method(s)
    func getSponsors() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .allSponsors)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: AllSponsorsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.sponsors.value = responseData.data
            self.delegate?.showHideHUD(showVal: false)
            
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
}

