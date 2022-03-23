//
//  DisplayAlertManager.swift
//  PlayerPoll
//
//  Created by mac on 12/10/21.
//

import UIKit

class DisplayAlertManager : NSObject, UITextFieldDelegate {
    static var shared = DisplayAlertManager()
    //------------------------------------------------------
    //MARK: Customs
    
    func displayAlert(target : AnyObject? = nil, animated : Bool, message : String, okTitle: String, handlerOK:(()->Void)?) {
        DispatchQueue.main.async {
            if let controller : UIViewController = UIApplication.topViewController() {
                let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
                let actionOK = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default) { (OK : UIAlertAction) in
                    handlerOK?()
                }
                alertController .addAction(actionOK)
                controller .present(alertController, animated: animated, completion: nil)
            }
        }
    }
    
    func displayAlertWithCancelOk(target : UIViewController, animated : Bool, message : String, alertTitleOk: String, alertTitleCancel: String, handlerCancel:@escaping (()->Void), handlerOk:@escaping (()->Void)) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let actionCancel = UIAlertAction(title: alertTitleCancel, style: UIAlertAction.Style.default) { (CANCEL : UIAlertAction) in
                
                handlerCancel()
            }
            
            let actionSave = UIAlertAction(title: alertTitleOk, style: UIAlertAction.Style.default) { (SAVE : UIAlertAction) in
                
                handlerOk()
            }
            
            alertController .addAction(actionCancel)
            alertController .addAction(actionSave)
            
            target.present(alertController, animated: animated, completion: nil)
        }
    }
    
    func presentJoinCodeAlert(animated : Bool, receivedInput:((String)->Void)?){
        DispatchQueue.main.async {
            if let controller : UIViewController = UIApplication.topViewController() {
                let alertController = UIAlertController(title: kAppName, message: "Please enter your event code. It will look something like '6Ytrgh' and has been sent to your registration email.", preferredStyle: UIAlertController.Style.alert)
                alertController.addTextField { (tf) in
                    tf.placeholder = "Enter event code"
                    tf.textAlignment = .center
                }
                let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (CANCEL : UIAlertAction) in
                }
                let actionSave = UIAlertAction(title: "Submit", style: UIAlertAction.Style.default) { (SAVE : UIAlertAction) in
                    if let tf = alertController.textFields?[0]{
                        receivedInput?(tf.text ?? "")
                    }
                }
                alertController .addAction(actionCancel)
                alertController .addAction(actionSave)
                controller.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
}
