//
//  AddEditBackgroundVM.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 18/11/21.
//

import Foundation
import Alamofire

protocol AddEditBackgroundVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
    func showErrorMessage(message: String)
    func addedBackgroundSuccessfully()
}

class AddEditBackgroundVM{
    
    var delegate:AddEditBackgroundVMProtocol?
    var pickedImage:Observable<Bool> = Observable(false)
    //MARK:- (D.E.) Dependency Injection
    init(delegate:AddEditBackgroundVMProtocol) {
        self.delegate = delegate
    }
    
    func setForFailedPic(){
        pickedImage.value = false
    }
    //Mark:- Validation Method(s)
    func submitTapped(with background: String, type: String, data: Data?, editId: String = ""){
        if background.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterBackgroundName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if type.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectBackgroundType, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if !pickedImage.value{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kPickBGPicture, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        hitAddBackground(background: background, data: data, bgId: editId, category: type)
    }
    func hitAddBackground(background : String , data : Data?, bgId : String, category: String){
        if !Reachability.isConnectedToNetwork(){
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .addEditBackground)
        let catId = category.retrieveCategory().getID
        let params = ["authToken":Globals.authToken, "bgName":background, "bgID":bgId.isEmpty ? "0":bgId,"catID":catId] as [String:AnyObject]
        var imageArray = [[String:Any]]()
        if let imageData = data{
            imageArray.append(["param":"backgroundImage", "imageData":imageData])
        }
        DataManager.requestPOSTWithFormData(type: AddEditBackgroundResponse.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: imageArray) { response , status in
            self.delegate?.showHideHUD(showVal: false)
            if response.status == 200 {
                self.delegate?.addedBackgroundSuccessfully()
            }else{
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }

        
    }
    
}
  
