//
//  AllRequestsVM.swift
//  PlayerPoll
//
//  Created by mac on 14/12/21.
//

import Alamofire

class AllRequestsVM{
    
    var delegate:ProgressHUDProtocol?
    
    var rewards: Observable<[Rewards]> = Observable([])

    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    
    //MARK:- Service Call Method(s)
    func getRewards() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getAllRewardsRequest)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: RewardsListingResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.rewards.value = responseData.data ?? []
            self.delegate?.showHideHUD(showVal: false)
            
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    
}

