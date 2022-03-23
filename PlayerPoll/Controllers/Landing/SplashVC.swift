//
//  SplashVC.swift
//  PlayerPoll
//
//  Created by mac on 11/10/21.
//

import UIKit

class SplashVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var tagLineLbl: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    //MARK:- Variable Declarations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("entered splash")
        tagLineLbl.alpha = 0
        holderView.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logoImageView.transform = logoImageView.transform.scaledBy(x: 0.005, y: 0.005)
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.logoImageView.isHidden = false
            self.logoImageView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.transitionCurlUp]) {
                self.holderView.alpha = 1
            } completion: { val in
                self.logoImageView.shake {
                    UIView.animate(withDuration: 0.5) {
                        self.tagLineLbl.alpha = 1
                        self.perform(#selector(self.navigateForward), with: nil, afterDelay: 1)
                    }
                }
            }
        })
    }
    
    @objc func navigateForward(){
        let uid = Globals.authToken
        if uid.isEmpty || uid != "uid"{
            print(Globals.detailsSubmitted)
            if !Globals.detailsSubmitted{
                let vc = IdentifierQuestionVC.instantiate(fromAppStoryboard: .Landing)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                appDelegate().setHomeScreen()
            }
        }else{
            let vc = LoginVC.instantiate(fromAppStoryboard: .Landing)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Configuring UI Method(s)
    
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
}


extension UIView {
    func shake(_ duration: Double? = 0.4, completion: @escaping(()->Void)) {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: duration ?? 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }
}


