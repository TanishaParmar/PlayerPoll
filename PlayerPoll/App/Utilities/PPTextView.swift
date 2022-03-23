//
//  PPTextView.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit


//Login
class PPLoginTextView: UITextView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        self.isEditable = false
        self.textAlignment = .center
        isScrollEnabled = false
        self.attributedText = DesignHelper.setSignupTextView()
        self.linkTextAttributes = [NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16) as Any,NSMutableAttributedString.Key.foregroundColor:PPColor.bgYellow]
    }
}


//Register
class PPRegisterTextView: UITextView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        self.isEditable = false
        isScrollEnabled = false
        self.textAlignment = .center
        self.attributedText = DesignHelper.setSignInTextView()
        self.linkTextAttributes = [NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16) as Any,NSMutableAttributedString.Key.foregroundColor:PPColor.bgYellow]
    }
}


class PPTermsTextView: UITextView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        self.isEditable = false
        isScrollEnabled = false
        self.textAlignment = .center
        self.attributedText = DesignHelper.setTermsTextView()
        self.linkTextAttributes = [NSMutableAttributedString.Key.font:PPFont.codeProBold(size: 16) as Any,NSMutableAttributedString.Key.foregroundColor:PPColor.bgYellow]
    }
}


//Identifiers

class PPBioTextView: UITextView,UITextViewDelegate{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        backgroundColor = .white
        cornerRadius = 10
        self.isEditable = true
        isScrollEnabled = true
        clearsOnInsertion = true
        self.text = "Text Here.."
        self.textColor = .gray
        delegate = self
        self.font = PPFont.codeProBold(size: 16)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Text Here.."{
            textView.textColor = .black
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Text Here.."{
            textView.textColor = .gray
            textView.text = "Text Here.."
        }
    }
}

// Create Poll
class PPPollTextView: UITextView,UITextViewDelegate{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentInset = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
        backgroundColor = .white
        self.isEditable = true
        isScrollEnabled = true
        clearsOnInsertion = true
        self.text = "Type here"
        self.textColor = .gray
        delegate = self
        self.font = PPFont.codeProBold(size: 16)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type here"{
            textView.textColor = .black
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Type here"{
            textView.textColor = .gray
            textView.text = "Type here"
        }
    }
}
