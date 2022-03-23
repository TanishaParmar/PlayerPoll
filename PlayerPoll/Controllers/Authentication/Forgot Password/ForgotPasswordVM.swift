//
//  ForgotPasswordVM.swift
//  PlayerPoll
//
//  Created by mac on 23/12/21.
//

import Foundation


import Alamofire


protocol ForgotViewModalProtocol {
    func showHideHUD(showVal: Bool)
    func navigateForward()
    func showErrorMessage(message: String)
}

class ForgotPasswordViewModal{
                
    var delegate: ForgotViewModalProtocol?
    
    init(delegate: ForgotViewModalProtocol) {
        self.delegate = delegate
    }
    
    
    func submitTapped(with email: String) {
        if email.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterEmail, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if !ValidationManager.shared.isValid(text: email, for: .email){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterValidEmail, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        hitForgotApi(with: email)
    }
    
    func hitForgotApi(with email: String){
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .forgetPassword)
        let params = ["email":email,] as [String:AnyObject]
        DataManager.requestPOSTWithFormData(type: CreateEditPollResponse.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if response.status == 200{
                self.delegate?.navigateForward()
            }else{
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }
    }
    
}
