//
//  AddEditSponsorVM.swift
//  PlayerPoll
//
//  Created by mac on 17/11/21.
//

import Foundation
import Alamofire

protocol AddEditSponsorVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
    func showErrorMessage(message: String)
    func addedSponsorSuccessfully()
}

class AddEditSponsorVM{
    
    var delegate:AddEditSponsorVMProtocol?
    var pickedImage:Observable<Bool> = Observable(false)
    //MARK:- (D.E.) Dependency Injection
    init(delegate: AddEditSponsorVMProtocol) {
        self.delegate = delegate
    }
    
    func setForFailedPic(){
        pickedImage.value = false
    }
    //MARK:- Validation Method(s)
    
    func submitTapped(with sponsor: String, data: Data?, editId: String = ""){
        if sponsor.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterSponsorName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if !pickedImage.value{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kPickSponsorPicture, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        hitAddSponsor(sponsor: sponsor, data: data, sponsorId: editId)
    }
    
    
    func hitAddSponsor(sponsor: String, data: Data?, sponsorId: String){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .addEditSponsor)
        let params = ["authToken":Globals.authToken,"sponsorName":sponsor,"sponsorID": sponsorId.isEmpty ? "0" : sponsorId] as [String:AnyObject]
        var imagArray = [[String:Any]]()
        if let imageData = data{
            imagArray.append(["param":"sponsorImage","imageData":imageData])
        }
        DataManager.requestPOSTWithFormData(type: AddSponsorResponse.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: imagArray) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if response.status == 200{
                self.delegate?.addedSponsorSuccessfully()
            }else{
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }
    }
    
    
    
}

