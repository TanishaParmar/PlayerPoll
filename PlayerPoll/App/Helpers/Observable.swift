//
//  Observable.swift
//  Betbetter2
//
//  Created by mac on 06/07/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation



class Observable<T>{
    
    var value: T{
        didSet{
            listener?(value)
        }
    }
    
    private var listener:((T)->Void)?
    
    init(_ value: T){
        self.value = value
    }
    
    func bind(_ closure: @escaping((T)->Void)){
        closure(value)
        listener = closure
    }
    
}
