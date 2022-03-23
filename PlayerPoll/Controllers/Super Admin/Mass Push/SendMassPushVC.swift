//
//  SendMassPushVC.swift
//  PlayerPoll
//
//  Created by mac on 15/12/21.
//

import UIKit

class SendMassPushVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var bodyTV: PPPollTextView!
    //MARK:- Variable Declarations
    var vm: SendMassPushVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Send a Notification", showBack: true, alignMiddle: true, delegate: self)
        vm = SendMassPushVM(delegate: self)
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func submitBtnAction(_ sender: PPBackgroundsSaveImageButton) {
        self.view.endEditing(true)
        vm?.validate(body: bodyTV.text)
    }
    
}

//MARK: - Nav Header Delegate Method(s)
extension SendMassPushVC: NavHeaderDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- ViewModal Delegate Datasource Method(s)
extension SendMassPushVC: SendMassPushVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    func showSuccessMessage() {
        DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "Push sent successfully!", okTitle: "Ok") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "OK", handlerOK: nil)
    }
}
