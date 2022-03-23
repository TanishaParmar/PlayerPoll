//
//  CustomExtensions.swift
//  Betbetter2
//
//  Created by apple on 11/03/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
//MARK:  UIApplication

extension UIApplication {
    
    class func topViewController(base: UIViewController? = appDelegate().window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}



//MARK:  String

extension String {
    
    public func toTrim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func toDictionary() -> [AnyHashable: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    func setColor(_ color: UIColor, ofSubstring substring: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: substring)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attributedString
    }
    
    func toIntVal()->Int{
        return NumberFormatter().number(from: self)?.intValue ?? 0
    }
    func toDoubleVal()->Double{
        return NumberFormatter().number(from: self)?.doubleValue ?? 0.0
    }
}


//MARK:- Double

extension Double{
    func toStringVal()->String{
        return String(format: "%.2f", self)
    }
    func toSingleDecimalString()->String{
        return String(format: "%.1f", self)
    }
    func toIntVal()->Int{
        return Int(self)
    }
}


extension String{
    func returnDiamondCurrency(isSmall:Bool = false)->NSAttributedString{
        let fullString = NSMutableAttributedString(string: "")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: isSmall ? "diamondMax" : "diamond")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " \(self)"))
        return fullString
    }
    
    func returnDiamondCurrencyForCustom(value: String)->NSAttributedString{
        let fullString = NSMutableAttributedString(string: "\(value) ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: value == "max" ? "diamondMax" : "diamond")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " \(self)"))
        return fullString
    }
    
    func returnDiamondCurrencyForCustomWhite(value: String)->NSAttributedString{
        let fullString = NSMutableAttributedString(string: "\(value) ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: value == "max" ? "diamondMax" : "diamond")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " \(self)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white]))
        return fullString
    }
    
    func getSortByText()->NSAttributedString{
        let fullString = NSMutableAttributedString(string: "\(self) ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "downArrow")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        return fullString
    }
}



extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

extension UIViewController{
    func setCreateAccountNavHeight(constraint: NSLayoutConstraint){
        if UIDevice().hasNotch{
            constraint.constant = 120
        }else{
            constraint.constant = 100
        }
    }
    
    func setUserNavHeight(constraint: NSLayoutConstraint){
        if UIDevice().hasNotch{
            constraint.constant = 50
        }else{
            constraint.constant = 50
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

