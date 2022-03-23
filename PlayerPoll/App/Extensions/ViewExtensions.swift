//
//  ViewExtensions.swift
//  Betbetter2
//
//  Created by apple on 10/03/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

extension UIView{
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func toImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func defaultShaddow() {
        
        self.layoutIfNeeded()
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 20
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


//MARK:- View background

extension UIView{
    func addBGGradient(frame: CGRect){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.0431372549, green: 0.2235294118, blue: 0.5019607843, alpha: 1).cgColor, #colorLiteral(red: 0.1333333333, green: 0.3607843137, blue: 0.8, alpha: 1).cgColor]//Colors you want to add
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0,1]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })
         
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

//MARK:- UINavigation COntroller

extension UINavigationController {
    func transparent() {
        self.setNavigationBarHidden(false, animated: true)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
        self.navigationItem.removeBackButtonText()
    }
    func backToViewController(vc: Any) {
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

//MARK:- UIImage
extension UIImage{
    func convertImageToBase64() -> String {
        let imageData = self.jpegData(compressionQuality: 0.4)!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}


extension UINavigationItem {
    func removeBackButtonText() {
        let attributes = [NSAttributedString.Key.font:  UIFont(name: "Manrope-Bold", size: 0.0)!, NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
}



extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
}


extension UIImageView{
    func setImage(with url: String){
        self.sd_imageTransition = .fade
        self.sd_setImage(with: URL(string: url))
    }
    
    func setImage(with url: String, error: @escaping((Error)->Void)){
        self.sd_imageTransition = .fade
        self.sd_setImage(with: URL(string: url)) { img, err, cache, url in
            guard let errObj = err else {return}
            error(errObj)
        }
    }
    
    func setSponsor(url: String){
        self.sd_imageTransition = .fade
        self.sd_setImage(with: URL(string: url)) { img, err, cache, url in
            guard let _ = err else {return}
            self.image = UIImage(named: "appLogo")
        }
    }
    
    func setImageWithBGPlaceHolder(with url: String){
        self.sd_imageTransition = .fade
        self.sd_setImage(with: URL(string: url)) { img, err, cache, url in
            guard let _ = err else {return}
            self.image = UIImage(named: "gradientBg")
        }
    }
    
    func setImageWithPlaceHolder(with url: String){
        self.sd_imageTransition = .fade
        self.sd_setImage(with: URL(string: url)) { img, err, cache, url in
            guard let _ = err else {return}
            self.image = UIImage(named: "placeholder")
        }
    }
}



extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func standardShadow() {
        self.applySketchShadow(color: UIColor(red: 103/255.0, green: 125/255.0, blue: 192/255.0, alpha: 1.0), alpha: 0.3, x: 8, y: 8, blur: 30, spread: 0)
    }
    
}

extension UIView{
    
    func fadeIn() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
        
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font:PPFont.codeProBold(size: 16)], context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,attributes: [.font:PPFont.codeProBold(size: 16)], context: nil)
        return ceil(boundingBox.width)
    }
}

extension UIView {

    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    func takeCornerRadiusScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    
}

extension UIImage{
    func addWaterMark() -> UIImage?{
        let watermarkImage = #imageLiteral(resourceName: "appLogo")
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        watermarkImage.draw(in: CGRect(x: self.size.width - 120, y: self.size.height - 120, width: 80, height: 80))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func addSurveyWaterMark() -> UIImage?{
        let watermarkImage = #imageLiteral(resourceName: "watermark")
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        watermarkImage.draw(in: CGRect(x: self.size.width - 170, y: self.size.height - 30, width: 150, height: 21))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}
