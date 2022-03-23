//
//  ManageBackgroundsVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 15/11/21.
//

import UIKit

class ManageBackgroundsVC: UIViewController,UITextFieldDelegate {
    
    //Mark:- IBOutlets
    
    @IBOutlet weak var textName: PPRegularTextField!
    @IBOutlet weak var textType: PPManageBackgroundsTextField!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var picker:ImagePicker?
    var vm :AddEditBackgroundVM?
    var editObj:Backgrounds?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK:- Configuring UI Method(s)
    
    func configureUI(){
        picker = ImagePicker(presentationController: self, delegate: self)
        PPCustomHeader.setNavHeaderView(view: navView, title: "Manage Backgrounds", showBack: true, alignMiddle: true, delegate: self)
        textName.delegate = self
        textType.delegate = self
        textName.isSecureTextEntry = false
        vm = AddEditBackgroundVM(delegate: self)
        vm?.pickedImage.bind({ val in
            if !val{
                self.imgBackground.image = UIImage(named: "placeholder")
            }
        })
        guard let obj = editObj else {return}
        self.vm?.pickedImage.value = true
        imgBackground.setImage(with: obj.bgImage) { err in
            self.vm?.setForFailedPic()
        }
        self.textName.text = obj.bgName
        self.textType.text = obj.catID.getCategory().rawValue
    }
    
    @IBAction func btnUpload(_ sender: UIButton) {
        picker?.present(from:sender)
    }
    
    @IBAction func btnRemoveImg(_ sender: UIButton) {
        self.vm?.pickedImage.value = false
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        self.view.endEditing(true)
        let editId = self.editObj?.bgID ?? ""
        self.vm?.submitTapped(with: textName.text!, type: textType.text!, data: imgBackground.image?.jpegData(compressionQuality: 0.6), editId: editId)
    }
}
//MARK:- Nav Header Delegate Method(s)

extension ManageBackgroundsVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- Image Picker Delegate Method(s)
extension ManageBackgroundsVC: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        if let img = image{
            vm?.pickedImage.value = true
            self.imgBackground.image = img
        }else{
            vm?.setForFailedPic()
        }
    }
}
//MARK:- VIew Modal Delegate Method(s)
extension ManageBackgroundsVC: AddEditBackgroundVMProtocol{
    func addedBackgroundSuccessfully() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
    }
    

    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
