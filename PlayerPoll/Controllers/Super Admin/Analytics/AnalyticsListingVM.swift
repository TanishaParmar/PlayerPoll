//
//  AnalyticsListingVM.swift
//  PlayerPoll
//
//  Created by mac on 06/12/21.
//

import Foundation
import Alamofire

class AnalyticsListingVM{
    
    var delegate:ProgressHUDProtocol?
    
    var data: Observable<[AnalyticsDetails]> = Observable([])
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    
    //MARK:- Service Call Method(s)
    func getAnalytics() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getAnalytics)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: AnalyticsModalResponse.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if let data = responseData.data{
                self.data.value = [AnalyticsDetails(type: .users, value: data.totalUsers),AnalyticsDetails(type: .changeUsers, value: "\(data.totalUsersInPercentage)"),AnalyticsDetails(type: .totalPolls, value: data.totalPoll),AnalyticsDetails(type: .totalPollResponses, value: data.totalPollResponse),AnalyticsDetails(type: .pollResponseAvg, value: data.totalPollResponseInAvg),AnalyticsDetails(type: .sponsors, value: data.totalSponsor),AnalyticsDetails(type: .sponsoredPolls, value: data.totalSponsorPoll),AnalyticsDetails(type: .totalPollViews, value: data.totalPollView)]
            }
            self.delegate?.showHideHUD(showVal: false)
            
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
}

