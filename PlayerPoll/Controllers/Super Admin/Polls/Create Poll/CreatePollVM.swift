//
//  CreatePollVM.swift
//  PlayerPoll
//
//  Created by mac on 24/11/21.
//

import Alamofire


protocol CreatePollVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
    func showAlert(message: String)
    func showSuccessMessage()
    func editPollObj(obj: SuperAdminPolls)
}

class CreatePollVM{
    
    var delegate:CreatePollVMProtocol?
    
    var options:Observable<[Options]> = Observable([Options(oid: "", option: ""),Options(oid: "", option: "")])
    
    var backgrounds:[Backgrounds] = []
    var sponsors:[Sponsors] = []
    var selectedBg: Backgrounds?
    var selectedSponsor: Sponsors?
    var categories:Observable<[CategoryData]> = Observable([])
    var selectedCategory:CategoryData?
    var fromEdit: Observable<Bool> = Observable(false)
    var pollObj: SuperAdminPolls?
    //MARK:- (D.E.) Dependency Injection
    init(delegate: CreatePollVMProtocol) {
        self.delegate = delegate
        
        let catOperation = BlockOperation {
            DataManager.getCategories { catData in
                self.categories.value = catData
                if self.fromEdit.value{
                    if let obj = self.pollObj{
                        self.delegate?.editPollObj(obj: obj)
                    }
                }
            } failure: {}
        }
        let sponsorsBGOperation = BlockOperation {
            self.getbackGroundsAndSponsors()
        }
        sponsorsBGOperation.addDependency(catOperation)
        let oq = OperationQueue()
        oq.addOperations([catOperation,sponsorsBGOperation], waitUntilFinished: false)
    }
    
    
    func addRemoveTapped(add: Bool){
        if add{
            guard options.value.count < 4 else {return}
            options.value.append(Options(oid: "", option: ""))
        }else{
            guard options.value.count > 2 else {return}
            options.value.removeLast()
        }
    }
    
    func inputOption(index: Int, text: String){
        self.options.value[index].option = text
    }
    
    func getbackGroundsAndSponsors(){
        let backgroundOperation = BlockOperation()
        backgroundOperation.addExecutionBlock {
            self.getBackgrounds {
                if self.fromEdit.value{
                    if let obj = self.pollObj{
                        self.delegate?.editPollObj(obj: obj)
                    }
                }
            }
        }
        
        let sponsorOperation = BlockOperation()
        sponsorOperation.addExecutionBlock {
            self.getSponsors {
                if self.fromEdit.value{
                    if let obj = self.pollObj{
                        self.delegate?.editPollObj(obj: obj)
                    }
                }
            }
        }
        sponsorOperation.addDependency(backgroundOperation)
        let oQ = OperationQueue()
        oQ.qualityOfService = .utility
        oQ.addOperations([backgroundOperation,sponsorOperation], waitUntilFinished: false)
    }
    
    //MARK:- Validation Method(s)
    
    func validate(pollText: String, points: String, category: String){
        if pollText.isEmpty || pollText == "Type here"{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPollText, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if selectedBg == nil{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectBackground, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        let optionsCheck = options.value.filter({$0.option.isEmpty}).isEmpty
        if !optionsCheck{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kFillOutPollOptions, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if category.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectCategory, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        
        if selectedSponsor == nil{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kSelectSponsor, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if points.isEmpty{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPollPoints, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        
        if points.toIntVal() == 0{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kEnterPollText, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
        if let cat = selectedCategory{
            if fromEdit.value{
                editPoll(pollText: pollText, points: points)
            }else{
                createPoll(pollText: pollText, points: points)
            }
        }else{
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kFillPollFields, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
            return
        }
    }
    
    
    //MARK:- Service Call Method(s)
    
    func createPoll(pollText: String, points: String){
        guard let bg = selectedBg, let sponsor = selectedSponsor, let cat = selectedCategory else {return}
        var params = ["authToken":Globals.authToken,"pID":"0","pollText":pollText,"bgID":bg.bgID,"catID":cat.catID,"points":points,"sponsorID":sponsor.sponsorID]
        for i in 0..<options.value.count{
            params["options\(i+1)"] = options.value[i].option
        }
        let url = getFinalUrl(with: .addEditPoll)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CreateEditPollResponse.self, strURL: url, params: params as [String:AnyObject], headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
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
    
    
    func editPoll(pollText: String, points: String){
        guard let poll = pollObj, let  bg = selectedBg, let sponsor = selectedSponsor, let cat = selectedCategory else {return}
        var params = ["authToken":Globals.authToken,"pID":poll.pID,"pollText":pollText,"bgID":bg.bgID,"catID":cat.catID,"points":points,"sponsorID":sponsor.sponsorID]
        for i in 0..<options.value.count{
            params["options\(i+1)"] = options.value[i].option
        }
        let url = getFinalUrl(with: .addEditPoll)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CreateEditPollResponse.self, strURL: url, params: params as [String:AnyObject], headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
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
    
    func getBackgrounds(completion: @escaping(()->Void)) {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .allBackgrounds)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: AllBackgroundsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            self.delegate?.showHideHUD(showVal: false)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.backgrounds = responseData.data
            completion()
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            completion()
            print(error)
        }
    }

    func getSponsors(completion: @escaping(()->Void)) {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .allSponsors)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: AllSponsorsResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.sponsors = responseData.data
            self.delegate?.showHideHUD(showVal: false)
            completion()
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            completion()
            print(error)
        }
    }
    
}
