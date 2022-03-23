//
//  RewardsGainedVC.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit

class RewardsGainedVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var upiTF: PPRegularTextField!
    @IBOutlet weak var venmoTF: PPRegularTextField!
    @IBOutlet weak var payPalTF: PPRegularTextField!
    @IBOutlet weak var mobileTF: PPRegularTextField!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var totalPoints: String = ""
    var vm:RewardsGainedVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Rewards", showBack: true, delegate: self)
        pointsLbl.text = totalPoints
        vm = RewardsGainedVM(delegate: self)
        mobileTF.keyboardType = .phonePad
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func submitBtnAction(_ sender: PPDoneIdentifierButton) {
        self.view.endEditing(true)
        self.vm?.submitTapped(with: mobileTF.text!, paypal: payPalTF.text!, upi: upiTF.text!, venmo: venmoTF.text!)
    }
    @IBAction func supportBtnAction(_ sender: UIButton) {
        guard Globals.userId != Globals.superAdminId else {return}
        let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
        vc.otherUser = Globals.superAdminId
        vc.name = "Support"
        vc.fromSuperAdmin = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK:- Nav Header Delegate Method(s)
extension RewardsGainedVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- View Modal Delegate Method(s)
extension RewardsGainedVC: RewardsGainedVMProtocol{
    func submitted(with status: Bool) {
        if status{
            DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "Submitted details successfully!", okTitle: "OK") {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            DisplayAlertManager.shared.displayAlert(animated: true, message: "Can't submit details now. Please try again later.", okTitle: "OK", handlerOK: nil)
        }
    }
    
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    
}
