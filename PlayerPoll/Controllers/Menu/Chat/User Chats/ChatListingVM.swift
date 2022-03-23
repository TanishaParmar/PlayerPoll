//
//  ChatListingVM.swift
//  PlayerPoll
//
//  Created by mac on 06/12/21.
//

import Foundation
import Alamofire

class ChatListingVM{
    
    var delegate:ProgressHUDProtocol?
    
    var userChats: Observable<[UserChats]> = Observable([])
    
    var page = 1
    
    var isLastPage = true
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Service Call Method(s)
    func getUserMessages() {
        let params = ["authToken":Globals.authToken,"type":"1","perPage":"20","pageNo":"\(page)"] as [String:AnyObject]
        let url = getFinalUrl(with: .getUsersMessagingList)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: UserChatsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if self.page == 1{
                self.userChats.value = responseData.data ?? []
            }else{
                if let data = responseData.data{
                    data.forEach { message in
                        let check = self.userChats.value.filter({$0.id == message.id}).isEmpty
                        if check{
                            self.userChats.value.append(message)
                        }
                    }
                }
            }
            self.isLastPage = responseData.lastPage ?? true
            if !self.isLastPage{
                self.page += 1
            }
            self.delegate?.showHideHUD(showVal: false)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
}

