//
//  RewardsGainedVM.swift
//  PlayerPoll
//
//  Created by mac on 14/12/21.
//

import Alamofire



protocol RewardsGainedVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
    func submitted(with status: Bool)
}

class RewardsGainedVM{
    
    var delegate:RewardsGainedVMProtocol?
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: RewardsGainedVMProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Validation Method(s)
    func submitTapped(with mobile: String, paypal: String, upi: String, venmo: String){
        if mobile.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPhone, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if paypal.isEmpty && upi.isEmpty && venmo.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kFillAtleastOnePayment, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        hitPaymentDetailsSubmit(mobile: mobile, paypal: paypal, upi: upi, venmo: venmo)
    }
    
    func hitPaymentDetailsSubmit(mobile: String, paypal: String, upi: String, venmo: String) {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken, "mobileNo": mobile, "paypal": paypal,"venmo":venmo,"upi":upi,"timeZone":TimeZone.current.identifier] as [String:AnyObject]
        let url = getFinalUrl(with: .submitRewardRequest)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: SubmitPaymentResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: []) { response, statusCode in
            print("response is =>",response)
            self.delegate?.showHideHUD(showVal: false)
            self.delegate?.submitted(with: response.status == 200)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
}

