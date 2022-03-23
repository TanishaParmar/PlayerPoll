//
//  PPTextField.swift
//  PlayerPoll
//
//  Created by mac on 13/10/21.
//

import UIKit

class PPBaseTextField:UITextField{
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    public var paddings: Double = 8

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


class PPRegularTextField: PPBaseTextField{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
    }
}

class PPPickerTextField: PPBaseTextField{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
    }
}

//Mark:- Sponsors

class PPSponsorsTextField: PPBaseTextField{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = PPFont.codeProBold(size: 17)
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0.594824791, alpha: 1)
    }
}
class PPManageBackgroundsTextField: PPRegularTextField, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,ToolbarPickerViewDelegate {
    
    var leftUserView: UIView {
        let imgView = UIImageView(image: UIImage(named: ""))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    private static let height: CGFloat = 20
    private static let crossButtonSize = CGSize(width: height, height: height)
    private let crossButtonView = UIButton(frame: CGRect(origin: CGPoint.zero, size: crossButtonSize))
    
    let pvPick = ToolbarPickerView()
    let pvOptions: [String] = Categories.allCases.map({$0.rawValue})
    var selectedOption: String? {
        didSet {
            self.text = selectedOption
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        rightView = leftUserView
        self.keyboardType = .default
        self.autocorrectionType = .no
        self.autocapitalizationType = .words
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "",
                                                        attributes:[NSAttributedString.Key.foregroundColor: PPColor.white])
        pvPick.dataSource = self
        pvPick.delegate = self
        inputView = pvPick
        pvPick.toolbarDelegate = self
        inputAccessoryView = pvPick.toolbar
        crossButtonView.contentMode = .center
        crossButtonView.setImage(UIImage(named: ""), for: UIControl.State.normal)
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: self.bounds.width - CGFloat(paddings * 3), y: CGFloat(paddings * 1.6)), size: CGSize(width: CGFloat(paddings) * 1.5, height: bounds.height -  CGFloat(paddings * 3.2)))
        
    }
    
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if selectedOption == nil {
            selectedOption = pvOptions.first
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pvOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pvOptions[row]
    }
    
    func didTapDone() {
        text = pvOptions[self.pvPick.selectedRow(inComponent: 0)]
        resignFirstResponder()
    }
    
    func didTapCancel() {
        text = ""
        resignFirstResponder()
    }
    
    //------------------------------------------------------
    
    //MARK: UIPickerViewDelegate
    
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
    }
}


class PPPollEditTextField: PPRegularTextField, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var leftUserView: UIView {
        let imgView = UIImageView(image: UIImage(named: ""))
        imgView.contentMode = .scaleAspectFit
        return imgView
    }
    
    private static let height: CGFloat = 20
    private static let crossButtonSize = CGSize(width: height, height: height)
    private let crossButtonView = UIButton(frame: CGRect(origin: CGPoint.zero, size: crossButtonSize))
    
    let pvPick = UIPickerView()
    let pvOptions: [String] = ["Select one","Select two","Select three","Select fourth"]
    var selectedOption: String? {
        didSet {
            self.text = selectedOption
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Customs
    
    func setup() {
        
        rightView = leftUserView
        
        self.placeholder = "Select one"
        self.keyboardType = .default
        self.autocorrectionType = .no
        self.autocapitalizationType = .words
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "",
                                                        attributes:[NSAttributedString.Key.foregroundColor: PPColor.white])
        
        
        pvPick.dataSource = self
        pvPick.delegate = self
        inputView = pvPick
        
        crossButtonView.contentMode = .center
        crossButtonView.setImage(UIImage(named: ""), for: UIControl.State.normal)
    }
    
    //------------------------------------------------------
    
    //MARK: Override
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: self.bounds.width - CGFloat(paddings * 3), y: CGFloat(paddings * 1.6)), size: CGSize(width: CGFloat(paddings) * 1.5, height: bounds.height -  CGFloat(paddings * 3.2)))
        
    }
    
    
    //------------------------------------------------------
    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if selectedOption == nil {
            selectedOption = pvOptions.first
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pvOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pvOptions[row]
    }
    
    //------------------------------------------------------
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = pvOptions[row]
    }
    
    //------------------------------------------------------
    
    //MARK: Init
    
    /// common text field layout for inputs
    ///
    /// - Parameter aDecoder: aDecoder description
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.delegate = self
    }
}
