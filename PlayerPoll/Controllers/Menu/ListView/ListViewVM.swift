//
//  ListViewVM.swift
//  PlayerPoll
//
//  Created by mac on 26/11/21.
//


import Alamofire

protocol ListViewVMProtocol: AnyObject {
    func showHideHUD(showVal: Bool)
    func showEmptyAlert(message: String)
}

class ListViewVM{
    
    var delegate:ListViewVMProtocol?
    
    var polls:Observable<[HomePolls]> = Observable([])
    var selectedCatId: Observable<String> = Observable("0")
    var categories: Observable<[CategoryData]> = Observable([])
    var page = 1
    var isLastPage = false

    //MARK:- (D.E.) Dependency Injection
    init(delegate: ListViewVMProtocol) {
        self.delegate = delegate
        getCategories()
    }
    
    func getCategories(){
        DataManager.getCategories { catData in
            self.categories.value = catData
        } failure: {
            
        }
    }
    
    
    
    //MARK:- Service Call Method(s)
    func getAllPolls(catId: String) {
        let params = ["authToken":Globals.authToken,"userID":Globals.userId,"type":"1","catID":catId,"perPage":"20","pageNo":"\(page)"] as [String:AnyObject]
        let url = getFinalUrl(with: .getUserPolls)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: HomeResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            if self.page == 1{
                self.polls.value = responseData.data ?? []
            }else{
                if let data = responseData.data{
                    data.forEach { poll in
                        let check = self.polls.value.filter({$0.pID == poll.pID}).isEmpty
                        if check{
                            self.polls.value.append(poll)
                        }
                    }
                }
            }
            print("cat colors", self.polls.value.map({$0.categoryDetails.catColor}))
            self.isLastPage = responseData.lastPage ?? true
//            if responseData.data?.isEmpty ?? true{
//                self.delegate?.showEmptyAlert(message: responseData.message)
//            }
            self.delegate?.showHideHUD(showVal: false)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }

    
}

