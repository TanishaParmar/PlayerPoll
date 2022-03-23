//
//  ManageBackgroundsListVM.swift
//  PlayerPoll
//
//  Created by mac on 17/11/21.
//

import Foundation
import Alamofire

protocol ProgressHUDProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
}

class ManageBackgroundsListVM{
    var delegate:ProgressHUDProtocol?
    var backgrounds: Observable<[Backgrounds]> = Observable([])
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Service Call Method(s)
    func getBackgrounds() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .allBackgrounds)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: AllBackgroundsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.backgrounds.value = responseData.data
            self.delegate?.showHideHUD(showVal: false)
            
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
}

