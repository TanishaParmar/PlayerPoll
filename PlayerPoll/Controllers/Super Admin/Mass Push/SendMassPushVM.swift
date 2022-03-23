//
//  SendMassPushVM.swift
//  PlayerPoll
//
//  Created by mac on 15/12/21.
//

import Alamofire

protocol SendMassPushVMProtocol {
    func showHideHUD(showVal: Bool)
    func showSuccessMessage()
    func showAlert(message: String)
}

class SendMassPushVM{
    
    var delegate:SendMassPushVMProtocol?
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: SendMassPushVMProtocol) {
        self.delegate = delegate
    }
    
    
    //MARK:- Validation Method(s)

    func validate(body: String){
        if body.isEmpty || body == "Type here"{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPushText, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        sendPush(body: body)
    }
    
    
    func sendPush(body: String){
        let params = ["authToken":Globals.authToken,"title":kAppName,"description":body]
        let url = getFinalUrl(with: .sendMassPush)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CreateEditPollResponse.self, strURL: url, params: params as [String:AnyObject], headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            self.delegate?.showHideHUD(showVal: false)
            if statusCode == 401 {
                appDelegate().setLogoutScreen()
                return
            }
            if statusCode == 200 {
                self.delegate?.showSuccessMessage()
            }else{
                self.delegate?.showAlert(message: responseData.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    
}


