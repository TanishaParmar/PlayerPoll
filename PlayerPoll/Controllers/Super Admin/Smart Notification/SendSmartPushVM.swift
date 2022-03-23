//
//  SendSmartPushVM.swift
//  PlayerPoll
//
//  Created by Phani's MacBook Pro on 19/01/22.
//

import Alamofire

protocol SendSmartPushVMProtocol {
    func showHideHUD(showVal: Bool)
    func showSuccessMessage()
    func showAlert(message: String)
}

class SendSmartPushVM{
    
    var delegate:SendSmartPushVMProtocol?
    
    var polls: [SuperAdminPolls] = []
    
    var selectedPoll:SuperAdminPolls?
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: SendSmartPushVMProtocol) {
        self.delegate = delegate
        self.getAllPolls {}
    }
    
    
    //MARK:- Validation Method(s)

    func validate(body: String, poll: String){
        if body.isEmpty || body == "Type here"{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPushText, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        guard let obj = selectedPoll, !poll.isEmpty else{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPollPushText, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        sendPush(body: body, pollId: obj.pID)
    }
    
    
    func sendPush(body: String, pollId: String){
        let params = ["authToken":Globals.authToken,"title":kAppName,"description":body,"pID":pollId]
        let url = getFinalUrl(with: .smartNotification)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CreateEditPollResponse.self, strURL: url, params: params as [String:AnyObject], headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            self.delegate?.showHideHUD(showVal: false)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if statusCode == 200{
                self.delegate?.showSuccessMessage()
            }else{
                self.delegate?.showAlert(message: responseData.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    func getAllPolls(completion: @escaping(()->Void)) {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .superAdminPolls)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: SuperAdminPollsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.polls = responseData.data.sorted(by: {$0.getCreationDate() > $1.getCreationDate()})
            self.delegate?.showHideHUD(showVal: false)
            completion()
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            completion()
            print(error)
        }
    }
    
    
}
