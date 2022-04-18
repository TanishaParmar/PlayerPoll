//
//  HUD.swift
//  PlayerPoll
//
//  Created by mac on 12/10/21.
//

import SVProgressHUD


class HUD{
    
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setForegroundColor(PPColor.appTheme)
        SVProgressHUD.setFont(UIFont(name: "Avenir-Black", size: 17)!)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingThickness(2)
        SVProgressHUD.setBackgroundColor(.clear)
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = false;
        }
    }
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = true;
        }
    }
    
    class func showHud(){
        DispatchQueue.main.async {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.setRingThickness(2)
            SVProgressHUD.setBackgroundColor(.clear)
            if let vc = UIApplication.topViewController(){
                vc.view.isUserInteractionEnabled = false;
            }
        }
    }
    
    class func isVisible()-> Bool{
        return SVProgressHUD.isVisible()
    }
    
    class func hideHud(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss();
            if let vc = UIApplication.topViewController(){
                vc.view.isUserInteractionEnabled = true;
            }
        }
    }
    
}
