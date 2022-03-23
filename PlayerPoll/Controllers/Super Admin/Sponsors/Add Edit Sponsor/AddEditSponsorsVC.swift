//
//  AddEditSponsorsVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 15/11/21.
//

import UIKit

class AddEditSponsorsVC: UIViewController,UITextFieldDelegate {

    //Mark:- IBOutlets
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var txtSponsors: PPSponsorsTextField!
    @IBOutlet weak var imgSponsors: UIImageView!
    
    //MARK:- Variable Declarations
    var picker:ImagePicker?
    var vm: AddEditSponsorVM?
    var editObj:Sponsors?
    override func viewDidLoad() {
        super.viewDidLoad()
       configureUI()
     
    }
    
    //MARK:- Configuring UI Method(s)
    
    func configureUI(){
        picker = ImagePicker(presentationController: self, delegate: self)
        PPCustomHeader.setNavHeaderView(view: navView, title: "Manage Sponsors", showBack: true, alignMiddle: true, delegate: self)
        txtSponsors.delegate = self
        vm = AddEditSponsorVM(delegate: self)
        vm?.pickedImage.bind({ val in
            if !val{
                self.imgSponsors.image = UIImage(named: "placeholder")
            }
        })
        guard let obj = editObj else {return}
        self.vm?.pickedImage.value = true
        imgSponsors.setImage(with: obj.sponsorImage) { err in
            self.vm?.setForFailedPic()
        }
        self.txtSponsors.text = obj.sponsorName
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        self.view.endEditing(true)
        let editId = self.editObj?.sponsorID ?? ""
        self.vm?.submitTapped(with: txtSponsors.text!, data: imgSponsors.image?.jpegData(compressionQuality: 0.6), editId: editId)
    }
    
    @IBAction func btnUpload(_ sender: UIButton) {
        picker?.present(from: sender)
    }
    
    @IBAction func btnRemoveImg(_ sender: UIButton) {
        self.vm?.pickedImage.value = false
    }
}
//MARK:- Nav Header Delegate Method(s)
extension AddEditSponsorsVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Image Picker Delegate Method(s)
extension AddEditSponsorsVC: ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        if let img = image{
            vm?.pickedImage.value = true
            self.imgSponsors.image = img
        }else{
            vm?.setForFailedPic()
        }
    }
}

//MARK:- VIew Modal Delegate Method(s)
extension AddEditSponsorsVC: AddEditSponsorVMProtocol{
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
    }
    
    func addedSponsorSuccessfully() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
