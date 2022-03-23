//
//  ChangePasswordVC.swift
//  PlayerPoll
//
//  Created by mac on 12/01/22.
//

import UIKit

class ChangePasswordVC: UIViewController {
    //MARK: IBOutlets
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var cnfNewPwdTF: PPRegularTextField!
    @IBOutlet weak var newPwdTF: PPRegularTextField!
    @IBOutlet weak var oldPwdTF: PPRegularTextField!
    //MARK: Variable Declarations
    var vm:ChangePasswordVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Change Password", showBack: true, alignMiddle: true, delegate: self)
        vm = ChangePasswordVM(delegate: self)
    }
    
    //MARK: Validation Method(s)
    
    
    //MARK: Service Call Method(s)
    
    
    //MARK: IBAction Method(s)
    
    @IBAction func submitBtnAction(_ sender: PPDoneIdentifierButton) {
        self.view.endEditing(true)
        self.vm?.submitTapped(with: oldPwdTF.text!, newPwd: newPwdTF.text!, confNewPwd: cnfNewPwdTF.text!)
    }
}


//MARK:- Nav Header Delegate Method(s)
extension ChangePasswordVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- ViewModal Delegate Datasource Method(s)
extension ChangePasswordVC: ChangePasswordVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    
    func navigateForward() {
        DisplayAlertManager.shared.displayAlert(animated: true, message: "Password changed successfully! Please login with new password.", okTitle: "Login") {
            appDelegate().setLogoutScreen()
        }
    }
    
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "OK", handlerOK: nil)
    }
}
