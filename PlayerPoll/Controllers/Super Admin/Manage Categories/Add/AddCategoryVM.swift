//
//  AddCategoryVM.swift
//  PlayerPoll
//
//  Created by mac on 24/12/21.
//

import Alamofire


class AddCategoryVM{
    
    var delegate:ForgotViewModalProtocol?
    
    var cat:CategoryData?
    
    var audioData:[AudioUserParse] = []
    var selectedAudio = (("",false),("",false),("",false))
    
    var selectedAudioObj:Observable<AudioUserParse?> = Observable(nil)
    var selectedAudio2Obj:Observable<AudioUserParse?> = Observable(nil)
    var selectedAudio3Obj:Observable<AudioUserParse?> = Observable(nil)

    //MARK:- (D.E.) Dependency Injection
    init(delegate: ForgotViewModalProtocol) {
        self.delegate = delegate
        self.getAudioData { data in
            self.audioData = data.map({AudioUserParse(data: $0)})
            if let cat = self.cat {
                if let firstObj = self.audioData.first(where: {$0.data.audID == cat.audID}){
                    self.selectedAudioObj.value = firstObj
                }
                if let oneObj = self.audioData.first(where: {$0.data.audID == cat.audID1}) {
                    print(oneObj)
                    self.selectedAudioObj.value = oneObj
                }
                if let secondObj = self.audioData.first(where: {$0.data.audID == cat.audID2}) {
                    print(secondObj)
                    self.selectedAudio2Obj.value = secondObj
                }
                if let thirdObj = self.audioData.first(where: {$0.data.audID == cat.audID3}) {
                    print(thirdObj)
                    self.selectedAudio3Obj.value = thirdObj
                }
            }
        }
    }
    
    func selectedButton(selectedButton1: Bool, selectedButton2: Bool, selectedButton3: Bool) {
        self.selectedAudio.0 = ("",selectedButton1)
        self.selectedAudio.1 = ("",selectedButton2)
        self.selectedAudio.2 = ("",selectedButton3)
    }
    
    //MARK:- Validation Method(s)
    func submitTapped(with catName: String, color: String, sound1: String, sound2: String, sound3: String) {
        if catName.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterCatName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }

        if color.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterCatName, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if sound1.isEmpty && sound2.isEmpty && sound3.isEmpty {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterCatSound, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        addCategoryApi(with: catName, catColor: color)
    }
    
    //MARK:- Service Call Method(s)
    func addCategoryApi(with catName: String, catColor: String) {
        self.delegate?.showHideHUD(showVal: true)
        let url = getFinalUrl(with: .addEditCategoryv2)
        print(url)
//        let params = ["authToken":Globals.authToken,"title":catName,"catID":cat?.catID ?? "0","catColor":catColor,"audID":self.selectedAudioObj.value?.data.audID ?? ""] as [String:AnyObject]
        
//        let params = ["authToken":Globals.authToken,"title":catName,"catID":cat?.catID ?? "0","catColor":catColor,"audioFile1":self.selectedAudioObj.value?.data.audID ?? "", "audioFile2":self.selectedAudio2Obj.value?.data.audID ?? "", "audioFile3":self.selectedAudio3Obj.value?.data.audID ?? ""] as [String:AnyObject]
        
        let params = ["authToken":Globals.authToken,"title":catName,"catID":cat?.catID ?? "0","catColor":catColor,"audID1":self.selectedAudioObj.value?.data.audID ?? "", "audID2":self.selectedAudio2Obj.value?.data.audID ?? "", "audID3":self.selectedAudio3Obj.value?.data.audID ?? ""] as [String:AnyObject]

        DataManager.requestPOSTWithFormData(type: CreateEditPollResponse.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { response, status in
            self.delegate?.showHideHUD(showVal: false)
            if response.status == 200 {
                self.delegate?.navigateForward()
            } else {
                self.delegate?.showErrorMessage(message: response.message)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error.message)
        }
    }
    
    func getAudioData(completion: @escaping(([AudioData])->Void)) {
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getAllAudio)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CategoryAudioResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            self.delegate?.showHideHUD(showVal: false)
            if statusCode == 401 {
                appDelegate().setLogoutScreen()
                return
            }
            if let audioData = data.data {
                completion(audioData)
            }
        } failure: { error in
            print(error)
            self.delegate?.showHideHUD(showVal: false)
            completion([])
        }
    }
    
    
}

