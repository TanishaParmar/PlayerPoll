//
//  CreatePollVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 17/11/21.
//

import UIKit

class CreatePollVC: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    // Mark :- IBOutlets
    @IBOutlet weak var minusImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtPollView: PPPollTextView!
    @IBOutlet weak var txtBackground: PPRegularTextField!
    @IBOutlet weak var txtPoints: PPRegularTextField!
    @IBOutlet weak var txtSponsor: PPRegularTextField!
    @IBOutlet weak var txtCategory: PPRegularTextField!
    
    var vm:CreatePollVM?
    var fromEdit = false
    var pollObj:SuperAdminPolls?
    var picker = ToolbarPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        txtSponsor.placeholder = "Select Sponsor"
        txtBackground.placeholder = "Select Background"
        tableView.register(UINib(nibName: "CreatePollCell", bundle: nil), forCellReuseIdentifier: "CreatePollCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm = CreatePollVM(delegate: self)
        vm?.fromEdit.value = fromEdit
        self.vm?.pollObj = self.pollObj
        vm?.options.bind({ val in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.heightConstraint.constant = CGFloat(val.count * 50)
            }
        })
        picker.delegate = self
        picker.dataSource = self
        picker.toolbarDelegate = self
        txtCategory.inputView = picker
        txtCategory.inputAccessoryView = picker.toolbar
    }
    
    func configureEditObj(){
        guard let poll = self.vm?.pollObj else {return}
        txtPollView.text = poll.pollText
        if let cat = self.vm?.categories.value.filter({$0.catID == poll.catID}).first{
            self.vm?.selectedCategory = cat
            txtCategory.text = cat.title
        }
        if let sponsor = vm?.sponsors.filter({$0.sponsorID == poll.sponsorID}).first{
            vm?.selectedSponsor = sponsor
            txtSponsor.text = sponsor.sponsorName
        }
        if let background = vm?.backgrounds.filter({$0.bgID == poll.bgID}).first{
            txtBackground.text = background.bgName
            vm?.selectedBg = background
        }
        txtPoints.text = poll.points
        vm?.options.value = poll.pollOptions.map({Options(oid: $0.optionID, option: $0.options)})
        _ = [minusImageView,plusImageView].map({$0?.isHidden = true})
    }
    
    func navigateToSelection(isBg: Bool = false){
        self.view.endEditing(true)
        let backgrounds = self.vm?.backgrounds ?? []
        let sponsors = self.vm?.sponsors ?? []
        if backgrounds.isEmpty{
            vm?.getBackgrounds {
                DispatchQueue.main.async { [weak self] in
                    self?.selection(isBg: true, backgrounds: self?.vm?.backgrounds ?? [], sponsors: sponsors)
                }
            }
        }else if sponsors.isEmpty{
            vm?.getSponsors {
                DispatchQueue.main.async { [weak self] in
                    self?.selection(backgrounds: backgrounds, sponsors:  self?.vm?.sponsors ?? [])
                }
            }
        }else{
            selection(isBg: isBg, backgrounds: backgrounds, sponsors: sponsors)
        }
    }
    
    func selection(isBg: Bool = false, backgrounds: [Backgrounds], sponsors: [Sponsors]){
        let vc = SelectBackSponsorsVC.instantiate(fromAppStoryboard: .SuperAdmin)
        vc.backgrounds = backgrounds
        vc.sponsors = sponsors
        vc.isBackground = isBg
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.sponsorTapped = { sponsor in
            vc.dismiss(animated: true) {
                self.vm?.selectedSponsor = sponsor
                self.txtSponsor.text = sponsor.sponsorName
            }
        }
        vc.backgroundTapped = { background in
            vc.dismiss(animated: true) {
                self.vm?.selectedBg = background
                self.txtBackground.text = background.bgName
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //Mark :- Actions
    @IBAction func selectSponsorAction(_ sender: UIButton) {
        navigateToSelection()
    }
    @IBAction func selectBgAction(_ sender: UIButton) {
        navigateToSelection(isBg: true)
    }
    @IBAction func btnPlus(_ sender: Any) {
        if vm?.fromEdit.value ?? false{
            return
        }
        vm?.addRemoveTapped(add: true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        self.view.endEditing(true)
        vm?.validate(pollText: txtPollView.text!, points: txtPoints.text!, category: txtCategory.text!)
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        if vm?.fromEdit.value ?? false{
            return
        }
        vm?.addRemoveTapped(add: false)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension CreatePollVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatePollCell", for: indexPath) as! CreatePollCell
        if let data = vm?.options.value[indexPath.row]{
            cell.txtOption.placeholder = "Option \(indexPath.row+1)"
            cell.txtOption.text = data.option
            cell.txtOption.tag = indexPath.row
            cell.txtOption.addTarget(self, action: #selector(endEditing(sender:)), for: .editingDidEnd)
        }
        return cell
    }
    
    @objc func endEditing(sender: UITextField){
        if let cell = sender.superview?.superview?.superview as? CreatePollCell, let iPath = tableView.indexPath(for: cell)?.row{
            vm?.inputOption(index: iPath, text: sender.text ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.options.value.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK:- VIew Modal Delegate Method(s)
extension CreatePollVC: CreatePollVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    func showSuccessMessage() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "Ok", handlerOK: nil)
        }
    }
    
    func editPollObj(obj: SuperAdminPolls) {
        print("edited pol aagya", obj)
        DispatchQueue.main.async {
            self.configureEditObj()
        }
    }
}

//MARK:- Picker View Delegate Datasource Method(s)
extension CreatePollVC: UIPickerViewDelegate,UIPickerViewDataSource, ToolbarPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.vm?.categories.value.count ?? 0
    }
    
    func didTapDone() {
        if let val = self.vm?.categories.value[self.picker.selectedRow(inComponent: 0)]{
            self.vm?.selectedCategory = val
            txtCategory.text = val.title
            txtCategory.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        self.txtCategory.text = ""
        self.txtCategory.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (self.vm?.categories.value[row].title ?? "").uppercased()
    }
}

