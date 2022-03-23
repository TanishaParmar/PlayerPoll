//
//  UserSettingsVC.swift
//  PlayerPoll
//
//  Created by mac on 21/10/21.
//

import UIKit

class UserSettingsVC: UIViewController {
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var emailTF: PPRegularTextField!
    @IBOutlet weak var userNameTF: PPRegularTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryTF: PPPickerTextField!
    //MARK:- Variable Declarations
    var vm: UserSettingsVM?
    var imgPicker:ImagePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI() {
        imgPicker = ImagePicker(presentationController: self, delegate: self)
        _ = [emailTF].map({$0?.isUserInteractionEnabled = false})
        userNameTF.isUserInteractionEnabled = true
        emailTF.isSecureTextEntry = false
        notificationSwitch.layer.borderWidth = 1.0;
        notificationSwitch.layer.cornerRadius = 16.0;
        notificationSwitch.layer.borderColor = PPColor.white.cgColor
        PPCustomHeader.setSaveHeaderView(view: navView, title: "Settings", showBack: true, alignMiddle: true,delegate: self) { [weak self] in
            guard let strongSelf = self else {return}
            let editedVal = strongSelf.vm?.imageEdited ?? false
            strongSelf.vm?.saveTapped(with: strongSelf.userNameTF.text!, data: editedVal ? strongSelf.profileImageView.image!.jpegData(compressionQuality: 0.7) : nil, notificationState: strongSelf.notificationSwitch.isOn ? "0" : "1")
        }
        vm = UserSettingsVM(delegate: self)
        vm?.details.bind({ details in
            DispatchQueue.main.async {
                if let userData = details{
                    self.profileImageView.contentMode = .scaleAspectFill
                    self.profileImageView.setImage(with: userData.profileImage) { err in
                        self.profileImageView.image = UIImage(named: "appLogo")
                        self.profileImageView.contentMode = .scaleAspectFit
                    }
                    self.userNameTF.text = userData.userName
                    self.emailTF.text = userData.email
                    self.notificationSwitch.setOn(userData.notificationDisable == "0", animated: true)
                }
            }
        })
        vm?.logoutConfirmedVal.bind({ val in
            if val{
                DisplayAlertManager.shared.displayAlertWithCancelOk(target: self, animated: true, message: "Are you sure you want to logout now?", alertTitleOk: "Logout", alertTitleCancel: "Cancel") {
                    
                } handlerOk: {
                    self.vm?.logoutTapped()
                }
            }
        })
        vm?.flagDetails.bind({ [weak self] details in
            guard let flagDetails = details else {return}
            self?.countryImageView.image = UIImage(named: flagDetails.imageName)
            self?.countryTF.text = flagDetails.countryName
        })
        vm?.getProfileData()
    }
    
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func selectCountryBtnAction(_ sender: UIButton) {
        Globals().getCountryData { flags in
            DispatchQueue.main.async {
                let vc = FlagSelectionVC.instantiate(fromAppStoryboard: .Landing)
                vc.flags = flags
                vc.selected = { flag in
                    vc.dismiss(animated: true) {
                        self.vm?.flagDetails.value = flag
                    }
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func editBioBtnAction(_ sender: PPEditIdentifierButton) {
        let vc = IdentifierQuestionVC.instantiate(fromAppStoryboard: .Landing)
        vc.fromSettings = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logoutBtnAction(_ sender: PPLogoutButton) {
        vm?.askForLogoutConfirmation()
    }
    @IBAction func uploadBtnAction(_ sender: PPUploadButton) {
        imgPicker?.present(from: sender)
    }
    
    @IBAction func changePwdAction(_ sender: PPEditIdentifierButton) {
        let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Menu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK:- Nav Header Delegate Method(s)
extension UserSettingsVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- VIew Modal Delegate Method(s)
extension UserSettingsVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}

//MARK:- Image Picker Delegate Method(s)
extension UserSettingsVC: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let img = image{
            self.profileImageView.image = img
            self.vm?.imageEdited = true
        }
    }
}
