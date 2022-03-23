//
//  PPFont.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit


struct PPFont {
    static let defaultRegularFontSize: CGFloat = 20.0
    static let zero: CGFloat = 0.0
    static let reduceSize: CGFloat = 3.0
    static let increaseSize : CGFloat = 2.0
    //"family: SF Pro Display"
    static func codeProLight(size: CGFloat?) -> UIFont{
        return UIFont(name: "CODE Light", size: size ?? defaultRegularFontSize)!
    }
    
    static func codeProBold(size: CGFloat?) -> UIFont{
        return UIFont(name: "Code Pro LC", size: size ?? defaultRegularFontSize)!
    }

    static func codeProExtraBold(size: CGFloat?) -> UIFont{
        return UIFont(name: "Code Pro Bold LC", size: size ?? defaultRegularFontSize)!
    }
    
    static func conthrax(size: CGFloat?) -> UIFont{
        return UIFont(name: "ConthraxSb-Regular", size: size ?? defaultRegularFontSize)!
    }
}


struct PPColor {
    static let bgYellow = #colorLiteral(red: 0.9448032379, green: 0.8246875405, blue: 0.3273252845, alpha: 1)
    static let buttonBlue = #colorLiteral(red: 0.06274509804, green: 0.1450980392, blue: 0.631372549, alpha: 1)
    static let identifierBlue = #colorLiteral(red: 0.06158444285, green: 0.1443035305, blue: 0.6303380132, alpha: 1)
    static let skyBlue = #colorLiteral(red: 0.2208191156, green: 0.7165477872, blue: 0.9993627667, alpha: 1)
    static let analyticsText = #colorLiteral(red: 0.2208191156, green: 0.7165477872, blue: 0.9993627667, alpha: 1)
    static let pointsGreen = #colorLiteral(red: 0.4907124639, green: 0.8420549035, blue: 0.3396229148, alpha: 1)
    static let submit = #colorLiteral(red: 0.01030017808, green: 0.08110887557, blue: 0.1754527688, alpha: 1)
    static let errorColor = #colorLiteral(red: 0.7907256484, green: 0.234187305, blue: 0.2413808405, alpha: 1)
    static let linkColor = #colorLiteral(red: 0.2, green: 0.5725490196, blue: 0.8666666667, alpha: 1)
    static let white = UIColor.white
    static let black = UIColor.black
    static let darkGray = UIColor.darkGray
    static let clear = UIColor.clear
    static let red = #colorLiteral(red: 0.9825670123, green: 0.2279840708, blue: 0.1802871227, alpha: 1)
    static let appTheme = #colorLiteral(red: 0.121389918, green: 0.3322204649, blue: 0.6949203014, alpha: 1)
    static let publish = #colorLiteral(red: 0.9887996316, green: 0.7253139615, blue: 0.1679992378, alpha: 1)
}
