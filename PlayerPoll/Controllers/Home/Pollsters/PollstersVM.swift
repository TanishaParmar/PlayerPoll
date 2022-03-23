//
//  PollstersVM.swift
//  PlayerPoll
//
//  Created by mac on 26/11/21.
//

import Foundation


class PollstersVM{
    
    var delegate: ProgressHUDProtocol?
    
    var pollsters: Observable<[SubmitAnswerUserDetail]> = Observable([])
    
    //MARK:- (D.E.) Dependency Injection
    init(delegate: ProgressHUDProtocol, data: [SubmitAnswerUserDetail]) {
        self.delegate = delegate
        self.pollsters.value = data
    }
    
    
    
    
    
    
    
    
}

