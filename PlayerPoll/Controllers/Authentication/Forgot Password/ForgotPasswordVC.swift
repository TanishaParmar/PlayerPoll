//
//  ForgotPasswordVC.swift
//  PlayerPoll
//
//  Created by mac on 23/12/21.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var emailTF: PPRegularTextField!
    
    //MARK:- Variable Declarations
    var vm: ForgotPasswordViewModal?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "", showBack: true, delegate: self)
        vm = ForgotPasswordViewModal(delegate: self)
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    @IBAction func submitBtnAction(_ sender: PPForgotSubmitButton) {
        self.view.endEditing(true)
        vm?.submitTapped(with: emailTF.text!)
    }
    
}


//MARK:- Nav Header Delegate Method(s)
extension ForgotPasswordVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- ViewModal Delegate Method(s)
extension ForgotPasswordVC: ForgotViewModalProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    
    func navigateForward() {
        DisplayAlertManager.shared.displayAlert(animated: true, message: "Email sent successfully!", okTitle: "OK") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "OK", handlerOK: nil)
    }
}
