//
//  ChangePasswordVM.swift
//  PlayerPoll
//
//  Created by mac on 12/01/22.
//

import Alamofire

protocol ChangePasswordVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
    func navigateForward()
    func showErrorMessage(message: String)
}

class ChangePasswordVM{
    
    var delegate:ChangePasswordVMProtocol?
    
    //MARK: (D.E.) Dependency Injection
    init(delegate: ChangePasswordVMProtocol) {
        self.delegate = delegate
    }
    
    func submitTapped(with oldPassword: String, newPwd: String, confNewPwd: String) {
        if oldPassword.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterOldPwd, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if newPwd.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterNewPwd, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if newPwd.count < 6{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kPasswordWeak, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if confNewPwd.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterConfNewPwd, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if newPwd != confNewPwd{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kPwdNotMatch, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        hitChangePwdApi(with: oldPassword, newPwd: newPwd)
    }
    
    func hitChangePwdApi(with pwd: String, newPwd: String){
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .changePwd)
        let params = ["authToken":Globals.authToken,"oldPassword":pwd,"newPassword":newPwd] as [String:AnyObject]
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

