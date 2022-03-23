//
//  NotificationsVM.swift
//  PlayerPoll
//
//  Created by mac on 15/11/21.
//

import Foundation
import Alamofire

protocol UserNotificationVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
}
class NotificationActivityVM {
    
    //MARK: - variable declaration
    var delegate:UserNotificationVMProtocol?
    var details:Observable<[Notifications]> = Observable([])
    var page = 1
    var isLastPage = false
    //MARK:- (D.E.) Dependency Injection
    init(delegate: UserNotificationVMProtocol) {
        self.delegate = delegate
    }
    
    func gerNotificationActivity() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let parm = ["authToken": Globals.authToken, "pageNo": "\(page)"] as [String : AnyObject]
        let url = getFinalUrl(with: .notificationActivity)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: NotificationResponseModel.self, strURL: url, params: parm, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, statusCode in
            print("response =>", response)
            self.delegate?.showHideHUD(showVal: false)
            if self.page == 1{
                self.details.value = response.data ?? []
            }else{
                if let data = response.data{
                    data.forEach { notif in
                        let check = self.details.value.filter({$0.notificationID == notif.notificationID}).isEmpty
                        if check{
                            self.details.value.append(notif)
                        }
                    }
                }
            }
            self.isLastPage = response.lastPage ?? true
        } failure: { error in
            print("error =>", error)
            self.delegate?.showHideHUD(showVal: false)
        }
    }
    
}
