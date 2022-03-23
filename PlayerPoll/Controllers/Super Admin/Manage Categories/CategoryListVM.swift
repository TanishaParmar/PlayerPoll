//
//  CategoryListVM.swift
//  PlayerPoll
//
//  Created by mac on 23/12/21.
//

import Alamofire

class CategoryListVM{
    
    var delegate:ProgressHUDProtocol?
    
    var categories: Observable<[CategoryData]> = Observable([])
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol) {
        self.delegate = delegate
    }
    
    //MARK:- Service Call Method(s)
    func getAllCategories() {
        let params = ["authToken":Globals.authToken] as [String:AnyObject]
        let url = getFinalUrl(with: .getAllCategoryv2)
        self.delegate?.showHideHUD(showVal: true)
        DataManager.requestPOSTWithFormData(type: CategoryDataResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.categories.value = responseData.data ?? []
            self.delegate?.showHideHUD(showVal: false)
        } failure: { error in
            self.delegate?.showHideHUD(showVal: false)
            print(error)
        }
    }
    
    
}

