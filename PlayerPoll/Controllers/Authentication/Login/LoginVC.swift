//
//  LoginVC.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit
import AuthenticationServices

class LoginVC: MyController,UITextViewDelegate {
    //MARK:- IBOutlets
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var signUpTextView: PPLoginTextView!
    @IBOutlet weak var passwordTF: PPRegularTextField!
    @IBOutlet weak var emailTF: PPRegularTextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var holderView: UIView!
    //MARK:- Variable Declarations
    var currentIndex = 0
    var imagesArraySlideshow = [UIImage(named: "56") ?? UIImage(), UIImage(named: "54") ?? UIImage()]
    var vm: LoginViewModal?
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
        signUpTextView.textAlignment = .center
        signUpTextView.delegate = self
        self.vm = LoginViewModal(delegate: self)
        self.vm?.rememberMe.bind({ val in
            self.checkImageView.image = UIImage(named: val ? "check" : "unCheck")
        })
        self.vm?.storedCredentials.bind({ [weak self] email, pwd in
            DispatchQueue.main.async {
                self?.emailTF.text = email
                self?.passwordTF.text = pwd
            }
        })
    }
    
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
    
    //MARK:- TextView Delegate Method(s)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "www.google.com"{
            let vc = RegisterVC.instantiate(fromAppStoryboard: .Landing)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func checkUncheckBtnAction(_ sender: UIButton) {
        self.vm?.rememberMe.value.toggle()
    }
    @IBAction func forgotPwdAction(_ sender: PPLoginTextButton) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Landing)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func loginBtnAction(_ sender: PPLoginButton) {
        self.view.endEditing(true)
        vm?.loginTapped(with: emailTF.text!, password: passwordTF.text!)
    }
    
    @IBAction func appleLoginBtnAction(_ sender: Any) {
        self.loginWithAppleTapped()
    }
    
    @IBAction func facebookLoginBtnAction(_ sender: Any) {
        vm?.loginWithFacebook(vc: self)
    }
}


extension LoginVC: LoginViewModalProtocol{
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
extension LoginVC: ASAuthorizationControllerDelegate{
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
