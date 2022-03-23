//
//  IdentifierViewModal.swift
//  PlayerPoll
//
//  Created by mac on 02/11/21.
//

import Foundation
import Alamofire

protocol IdentifierViewModalProtocol {
    func showHideHUD(showVal: Bool)
    func showErrorMessage(message: String)
    func updatedSuccessfully()
}

class IdentifierViewModal {
    
    var delegate:IdentifierViewModalProtocol?
    
    var genderIdentifiers:Observable<[GenderIdentifier]> = Observable([])
    var ageIdentifiers:Observable<[AgeIdentifiers]> = Observable([])
    var profile: Observable<Profile?> = Observable(nil)
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: IdentifierViewModalProtocol) {
        self.delegate = delegate
        genderIdentifiers.value = [GenderIdentifier(type: .she),GenderIdentifier(type: .he),GenderIdentifier(type: .them)]
        ageIdentifiers.value = [AgeIdentifiers(type: .babyBoomer),AgeIdentifiers(type: .genX),AgeIdentifiers(type: .millenial),AgeIdentifiers(type: .genZ)]
    }
    
    func modifyIdentifiers(index: Int, fromGender: Bool) {
        if fromGender {
            self.genderIdentifiers.value = self.genderIdentifiers.value.map({ identifier in
                var mutObj = identifier
                mutObj.selected = false
                return mutObj
            })
            self.genderIdentifiers.value[index].selected = true
        } else {
            self.ageIdentifiers.value = self.ageIdentifiers.value.map({ identifier in
                var mutObj = identifier
                mutObj.selected = false
                return mutObj
            })
            self.ageIdentifiers.value[index].selected = true
        }
    }
    
    
    func validateInputs(bio: String) {
        if bio.isEmpty || bio.contains("Text Here..") {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterBio, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        let genderIdentifier = self.genderIdentifiers.value.filter({$0.selected}).isEmpty
        if genderIdentifier {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectIdentity, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        let ageIdentifier = self.ageIdentifiers.value.filter({$0.selected}).isEmpty
        if ageIdentifier {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectAgeGroup, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        hitIdentifierApi(bio: bio)
    }
    
    func hitIdentifierApi(bio: String) {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let genderID = self.genderIdentifiers.value.filter({$0.selected}).first
        let genderType = genderID?.type.apiVal ?? ""
        let ageID = self.ageIdentifiers.value.filter({$0.selected}).first
        let ageType = ageID?.type.apiVal ?? ""
        
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .identifier)
        let params = ["bio":bio,"userIdentify":genderType,"userAgeGroup":ageType,"authToken":Globals.authToken] as [String:AnyObject]
        DataManager.requestPOSTWithFormData(type: IdentifiersResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if status == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if let data = response.message, response.status == 200{
                debugPrint("data =>", data)
                UserDefaults.standard.set(true, forKey: DefaultKeys.detailsSubmitted)
                self.delegate?.updatedSuccessfully()
            } else {
                self.delegate?.showErrorMessage(message: response.message!)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            debugPrint("error message =>",error.message)
        }
    }
    
    func getProfileData() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getProfile)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            print("data is =>",data)
            if statusCode == 401 {
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            self.profile.value = data.data
        } failure: { error in
            print(error)
            self.delegate?.showHideHUD(showVal: false)
        }
    }
    
}

