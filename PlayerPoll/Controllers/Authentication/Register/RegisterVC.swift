//
//  RegisterVC.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit
import AuthenticationServices
class RegisterVC: MyController,UITextViewDelegate {
    //MARK:- IBOutlets
    @IBOutlet weak var countryTF: PPPickerTextField!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var termsTV: PPTermsTextView!
    @IBOutlet weak var emailTF: PPRegularTextField!
    @IBOutlet weak var passwordTF: PPRegularTextField!
    @IBOutlet weak var userNameTF: PPRegularTextField!
    @IBOutlet weak var signInTV: PPRegisterTextView!
    //MARK:- Variable Declarations
    var currentIndex = 0
    var imagesArraySlideshow = [UIImage(named: "56") ?? UIImage(), UIImage(named: "54") ?? UIImage()]
    var vm: RegisterViewModal?
    var picker:ImagePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.slideshow()
        }
    }
    
    func slideshow() {
        currentIndex += 1
        if currentIndex == imagesArraySlideshow.count {
            currentIndex = 0
        }
        UIView.transition(with: self.bgImageView, duration: 2.0, options: .transitionCrossDissolve, animations: {
            self.bgImageView.image = self.imagesArraySlideshow[self.currentIndex]
        }) { (didFinish) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.slideshow()
            }
        }
    }
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        vm = RegisterViewModal(delegate: self)
        picker = ImagePicker(presentationController: self, delegate: self)
        signInTV.textAlignment = .center
        signInTV.delegate = self
        vm?.agreeTerms.bind({ val in
            self.checkImageView.image = UIImage(named: val ? "check" : "unCheck")
        })
        vm?.pickedImage.bind({ val in
            self.pickedImageView.backgroundColor = val ? .clear : .black
            self.pickedImageView.contentMode = val ? .scaleAspectFill : .scaleAspectFit
        })
        vm?.flagDetails.bind({ [weak self] details in
            guard let flagDetails = details else {return}
            self?.flagImageView.image = UIImage(named: flagDetails.imageName)
            self?.countryTF.text = flagDetails.countryName
        })
    }
    
    //MARK:- TextView Delegate Method(s)

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "www.google.com"{
            self.navigationController?.popViewController(animated: true)
        }
        return false
    }
    //MARK:- Validation Method(s)
    
    
    //MARK:- Apple SignIn Method(s)
    func loginWithAppleTapped(){
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
            DisplayAlertManager.shared.displayAlert(animated: true, message: "Minimum iOS13 or above is required for this feature.", okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
        }
    }
    
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
    
    @IBAction func fbLoginBtnAction(_ sender: UIButton) {
        vm?.loginWithFacebook(vc: self)
    }
    
    @IBAction func appleLoginBtnAction(_ sender: UIButton) {
        self.loginWithAppleTapped()
    }
    @IBAction func signUpAction(_ sender: PPLoginButton) {
        self.view.endEditing(true)
        vm?.signUpTapped(with: emailTF.text!, userName: userNameTF.text!, password: passwordTF.text!, data: pickedImageView.image?.jpegData(compressionQuality: 0.7))
    }
    
    @IBAction func checkBtnAction(_ sender: UIButton) {
        self.vm?.agreeTerms.value.toggle()
    }
    @IBAction func pickImageBtnAction(_ sender: UIButton) {
        picker?.present(from: sender)
    }
}

//MARK:- ViewModal Delegate Method(s)

extension RegisterVC: RegisterViewModalProtocol, ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let img = image{
            vm?.pickedImage.value = true
            self.pickedImageView.image = img
        }else{
            vm?.setForFailedPic()
        }
    }
    
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    
    func navigateForward(with val: Bool) {
        DispatchQueue.main.async {
            if val{
                appDelegate().setHomeScreen()
            }else{
                let vc = IdentifierQuestionVC.instantiate(fromAppStoryboard: .Landing)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
    }
    
}



//MARK:- Apple Login Delegate Method(s)
extension RegisterVC: ASAuthorizationControllerDelegate{
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        print(error.localizedDescription)
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? "")
            let email = appleIDCredential.email ?? ""
            print(userIdentifier,fullName,email,"details are here")
            if fullName != "" && userIdentifier != ""{
                let details = AppleLoginDetails(name: fullName, appleId: userIdentifier, email: email)
                AppleDataStoreManager.shared.saveAppleDetailsToDefaults(details: details)
                vm?.appleLogin(with: email, userName: fullName, appleToken: userIdentifier, appleImage: "")
            }else{
                AppleDataStoreManager.shared.retreiveAppleDetails(completion: { [weak self] (details) in
                    print(details,"details are heree")
                    self?.vm?.appleLogin(with: details.email, userName: details.name, appleToken: details.appleId, appleImage: "")
                }) { [weak self] in
                    self?.vm?.appleLogin(with: email, userName: fullName, appleToken: userIdentifier, appleImage: "")
                }
            }
        }
    }

}
