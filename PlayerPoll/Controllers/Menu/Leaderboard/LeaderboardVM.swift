//
//  LeaderboardVM.swift
//  PlayerPoll
//
//  Created by mac on 08/12/21.
//

import Foundation
import Alamofire

class LeaderboardVM{
    
    var delegate:ProgressHUDProtocol?
    
    var users:Observable<[Leaderboard]> = Observable([])
    
    var tableUsers:Observable<[Leaderboard]> = Observable([])
    var page = 1
    var lastPage = true
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    func getLeaderboard(with type: String) {
        let params = ["authToken":Globals.authToken,"dayType":type,"timeZone":TimeZone.current.identifier,"pageNo":"\(page)"] as [String:AnyObject]
        print(params)
        let url = getFinalUrl(with: .getLeaderboard)
        self.delegate?.showHideHUD(showVal: true)
        if page == 1{
            self.users.value = []
        }
        DataManager.requestPOSTWithFormData(type: LeaderboardResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if self.page == 1{
                self.users.value = (responseData.data ?? [])
            }else{
                if let data = responseData.data{
                    data.forEach { user in
                        let check = self.users.value.filter({$0.userID == user.userID}).isEmpty
                        if check {
                            self.users.value.append(user)
                        }
                    }
                }
            }
            self.lastPage = responseData.lastPage ?? true
            self.page += 1
            self.delegate?.showHideHUD(showVal: false)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    
}

