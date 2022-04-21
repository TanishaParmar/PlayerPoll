//
//  AddCategoryVC.swift
//  PlayerPoll
//
//  Created by mac on 24/12/21.
//

import UIKit

class AddCategoryVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var catNameTF: PPRegularTextField!
    
    @IBOutlet weak var soundTF: PPRegularTextField!
    @IBOutlet weak var soundTF2: PPRegularTextField!
    @IBOutlet weak var soundTF3: PPRegularTextField!
    @IBOutlet weak var colorTF: PPRegularTextField!
    //MARK:- Variable Declarations
    var vm:AddCategoryVM?
    var catData: CategoryData?
    var addedSuccessfully:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        catNameTF.autocapitalizationType = .words
        PPCustomHeader.setNavHeaderView(view: navView, title: "Add Category", showBack: true, alignMiddle: true, delegate: self)
        vm = AddCategoryVM(delegate: self)
        vm?.cat = catData
        vm?.selectedAudioObj.bind({ obj in
            guard let audio = obj else {return}
            if let path = URL(string: audio.data.audioFile)?.lastPathComponent{
                DispatchQueue.main.async {
                    self.soundTF.text = path
                }
            }
        })
        vm?.selectedAudio2Obj.bind({ obj in
            guard let audio = obj else {return}
            if let path = URL(string: audio.data.audioFile)?.lastPathComponent{
                DispatchQueue.main.async {
                    self.soundTF2.text = path
                }
            }
        })
        vm?.selectedAudio3Obj.bind({ obj in
            guard let audio = obj else {return}
            if let path = URL(string: audio.data.audioFile)?.lastPathComponent{
                DispatchQueue.main.async {
                    self.soundTF3.text = path
                }
            }
        })
        guard let data = self.catData else {return}
        catNameTF.text = data.title
        colorTF.text = data.catColor
        
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func submitBtnAction(_ sender: PPForgotSubmitButton) {
        self.view.endEditing(true)
//        self.vm?.submitTapped(with: catNameTF.text!, color: colorTF.text!, sound: soundTF.text!)
        self.vm?.submitTapped(with: catNameTF.text!, color: colorTF.text!, sound1: soundTF.text!, sound2: soundTF2.text!, sound3: soundTF3.text!)
    }
    
    @IBAction func selectColorBtnAction(_ sender: UIButton) {
        let vc = PickColorVC.instantiate(fromAppStoryboard: .SuperAdmin)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.pickedColor = { colorVal in
            vc.dismiss(animated: true) {
                self.colorTF.text = colorVal.toHexString()
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func soundSelectBtnAction(_ sender: UIButton) {
        vm?.selectedButton(selectedButton1: true, selectedButton2: false, selectedButton3: false)
        if vm?.audioData.isEmpty ?? true {
            vm?.getAudioData { [weak self] audios in
                self?.redirectToAudioSelection(audios: audios.map({AudioUserParse(data: $0)}))
            }
        } else {
            if let audios = self.vm?.audioData{
                self.redirectToAudioSelection(audios: audios)
            }
        }
    }
    
    @IBAction func soundSelect2BtnAction(_ sender: Any) {
        vm?.selectedButton(selectedButton1: false, selectedButton2: true, selectedButton3: false)
        if vm?.audioData.isEmpty ?? true {
            vm?.getAudioData { [weak self] audios in
                self?.redirectToAudioSelection(audios: audios.map({AudioUserParse(data: $0)}))
            }
        }else{
            if let audios = self.vm?.audioData{
                self.redirectToAudioSelection(audios: audios)
            }
        }
    }
    
    @IBAction func soundSelect3BtnAction(_ sender: Any) {
        vm?.selectedButton(selectedButton1: false, selectedButton2: false, selectedButton3: true)
        if vm?.audioData.isEmpty ?? true {
            vm?.getAudioData { [weak self] audios in
                self?.redirectToAudioSelection(audios: audios.map({AudioUserParse(data: $0)}))
            }
        }else{
            if let audios = self.vm?.audioData{
                self.redirectToAudioSelection(audios: audios)
            }
        }
    }
    
    func redirectToAudioSelection(audios: [AudioUserParse]){
        DispatchQueue.main.async {
            let vc = SelectAudioVC.instantiate(fromAppStoryboard: .SuperAdmin)
            vc.audios = audios
            vc.selectedObj = { obj in
                if (self.vm?.selectedAudio.0)! == ("",true) {
                    self.vm?.selectedAudioObj.value = obj
                } else if (self.vm?.selectedAudio.1)! == ("",true) {
                    self.vm?.selectedAudio2Obj.value = obj
                } else if (self.vm?.selectedAudio.2)! == ("",true) {
                    self.vm?.selectedAudio3Obj.value = obj
                }
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}



//MARK:- Nav Header Delegate Method(s)
extension AddCategoryVC: NavHeaderDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- ViewModal Delegate Method(s)
extension AddCategoryVC: ForgotViewModalProtocol {
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    
    func navigateForward() {
        let message = self.vm?.cat != nil ? "Category edited successfully!" : "Added category successfully!"
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "OK") { [weak self] in
            self?.addedSuccessfully?()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "OK", handlerOK: nil)
    }
}
