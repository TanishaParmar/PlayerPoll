//
//  HomeVM.swift
//  PlayerPoll
//
//  Created by mac on 26/11/21.
//

import Foundation
import Alamofire

protocol HomeVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
}

class HomeVM{
    
    var delegate:HomeVMProtocol?
    
    var polls:Observable<[HomePolls]> = Observable([])
    var profile: Observable<Profile?> = Observable(nil)
    var currentPoll:Observable<HomePolls?> = Observable(nil)
    var audios: [AudioData] = []
    var pageIndex = 1
    var lastPage = false
    //MARK:- (D.E.) Dependency Injection
    init(delegate: HomeVMProtocol) {
        self.delegate = delegate
        self.getQueuedData()
    }
    
    //MARK:- Service Call Method(s)
    func getAllPolls(pollId: String = "") {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        let params = ["authToken":Globals.authToken,"userID":Globals.userId,"type":"1","catID":"0","perPage":"15","pageNo":"\(pageIndex)","pID":pollId] as [String:AnyObject]
        print(params)
        
        let url = getFinalUrl(with: .getUserPolls2)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: HomeResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData, pollId)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if let data = responseData.data{
                data.forEach { poll in
                    let check = self.polls.value.filter({$0.pID == poll.pID}).isEmpty
                    if check{
                        self.polls.value.append(poll)
                    }
                }
            }
            self.pageIndex += 1
            self.lastPage = responseData.lastPage ?? true
            self.delegate?.showHideHUD(showVal: false)
            
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }

    //answer poll api
    
    func submitAnswer(optionId: String, pollId: String){
        let params = ["authToken":Globals.authToken,"pID":pollId,"optionID":optionId,"timeZone":TimeZone.current.identifier] as [String:AnyObject]
        print(params)
        let url = getFinalUrl(with: .submitPoll)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: PollSubmissionResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.getProfileData()
            if let poll = responseData.data{
                if let fIndex = self.polls.value.firstIndex(where: {$0.pID == poll.pID}){
                    self.polls.value[fIndex] = poll
                }
            }
            self.delegate?.showHideHUD(showVal: false)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    //profile data api

    func getProfileData() {
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getProfile)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: GetProfileResponseModel.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            if let userData = data.data {
                self.profile.value = userData
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    //update poll api

    func updatePollView(pollId: String) {
        let params = ["authToken":Globals.authToken,"pID":pollId] as [String:AnyObject]
        print(params,"poll update points")
        let url = getFinalUrl(with: .updatePollView)
        DataManager.requestPOSTWithFormData(type: RecordPollViewResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
        } failure: { error in
            print(error)
        }
    }
    
    //audio category data api

    func getAudioData(){
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getAllAudio)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CategoryAudioResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { data, statusCode in
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.delegate?.showHideHUD(showVal: false)
            if let audioData = data.data {
                self.audios = audioData
                print("audios received", audioData)
            }
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    func getQueuedData(){
        let b1 = BlockOperation {
            self.getProfileData()
        }
        
        let b2 = BlockOperation {
            self.getAudioData()
        }
        
        b2.addDependency(b1)
        
        let oq = OperationQueue()
        oq.qualityOfService = .userInitiated
        oq.addOperations([b1,b2], waitUntilFinished: false)
    }
    
    
    
    func getRelatedCategoryUrl(catId: String)->String{
        let filterContent = audios.filter({$0.catID == catId}).shuffled().randomElement()
        return filterContent?.audioFile ?? ""
    }
}

