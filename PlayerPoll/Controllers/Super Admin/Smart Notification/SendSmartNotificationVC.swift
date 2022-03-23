//
//  SendSmartNotificationVC.swift
//  PlayerPoll
//
//  Created by Phani's MacBook Pro on 19/01/22.
//

import UIKit

class SendSmartNotificationVC: UIViewController {
    //MARK: IBOutlet(s)
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var descTV: PPPollTextView!
    @IBOutlet weak var pollTF: PPRegularTextField!
    //MARK: Variable Declarations
    
    var vm: SendSmartPushVM?
    //MARK:- View Controller LifeCycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Send a Smart Notification", showBack: true, alignMiddle: true, delegate: self)
        vm = SendSmartPushVM(delegate: self)
    }

    func selectPolls(){
        let vc = SelectPollVC.instantiate(fromAppStoryboard: .SuperAdmin)
        vc.pollSelected = { poll in
            vc.dismiss(animated: true) {
                self.pollTF.text = poll.pollText
                self.descTV.text = poll.pollText
                self.vm?.selectedPoll = poll
            }
        }
        self.present(vc, animated: true) {
            vc.polls = self.vm?.polls ?? []
        }
    }
    
    //MARK: IBAction Method(s)
    @IBAction func selectPollBtnAction(_ sender: UIButton) {
        if (vm?.polls ?? []).isEmpty{
            self.vm?.getAllPolls(completion: {
                DispatchQueue.main.async {
                    self.selectPolls()
                }
            })
        }else{
            self.selectPolls()
        }
    }
    @IBAction func sendBtnAction(_ sender: PPBackgroundsSaveImageButton) {
        self.view.endEditing(true)
        self.vm?.validate(body: descTV.text!, poll: pollTF.text!)
    }
    
}
//MARK: - Nav Header Delegate Method(s)
extension SendSmartNotificationVC: NavHeaderDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- ViewModal Delegate Datasource Method(s)
extension SendSmartNotificationVC: SendSmartPushVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    func showSuccessMessage() {
        DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: "Smart Push sent successfully!", okTitle: "Ok") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "OK", handlerOK: nil)
    }
}
