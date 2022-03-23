//
//  IdentifierQuestionVC.swift
//  PlayerPoll
//
//  Created by mac on 16/10/21.
//

import UIKit

class IdentifierQuestionVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bioTextView: PPBioTextView!
    
    //MARK:- Variable Declarations
    var vm: IdentifierViewModal?
    var fromSettings = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cvHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        backBtn.isHidden = !fromSettings
        vm = IdentifierViewModal(delegate: self)
        collectionView.register(UINib(nibName: "AgeIdentifierCell", bundle: nil), forCellWithReuseIdentifier: "AgeIdentifierCell")
        collectionView.register(UINib(nibName: "GenderIdentifierCell", bundle: nil), forCellWithReuseIdentifier: "GenderIdentifierCell")
        collectionView.register(UINib(nibName: "IdentifierReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "IdentifierReusableView")
        collectionView.delegate = self
        collectionView.dataSource = self
        vm?.genderIdentifiers.bind({ val in
            self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0),IndexPath(item: 1, section: 0),IndexPath(item: 2, section: 0)])
        })
        vm?.ageIdentifiers.bind({ val in
            self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 1),IndexPath(item: 1, section: 1),IndexPath(item: 2, section: 1),IndexPath(item: 3, section: 1)])
        })
        
        vm?.profile.bind({ data in
            if let profileData = data{
                DispatchQueue.main.async {
                    self.bioTextView.text = profileData.bio
                    self.vm?.modifyIdentifiers(index: profileData.userAgeGroup.toIntVal()-1, fromGender: false)
                    self.vm?.modifyIdentifiers(index: profileData.userIdentify.toIntVal()-1, fromGender: true)
                }
            }
        })
        
        if fromSettings{
            vm?.getProfileData()
        }
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    @IBAction func doneBtnAction(_ sender: PPDoneIdentifierButton) {
        self.view.endEditing(true)
        vm?.validateInputs(bio: bioTextView.text!)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}



//MARK:- Collection View Delegate Datasource Method(s)
extension IdentifierQuestionVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return vm?.genderIdentifiers.value.count ?? 0
        }
        return vm?.ageIdentifiers.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenderIdentifierCell", for: indexPath) as! GenderIdentifierCell
            if let data = self.vm?.genderIdentifiers.value[indexPath.item]{
                cell.identifierLbl.text = data.type.rawValue
                cell.identifierLbl.textColor = PPColor.identifierBlue
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) {
                    cell.bgView.backgroundColor = data.selected ? PPColor.bgYellow : PPColor.white
                } completion: { _ in}
                return cell
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AgeIdentifierCell", for: indexPath) as! AgeIdentifierCell
        if let data = vm?.ageIdentifiers.value[indexPath.item]{
            cell.nameLbl.text = data.type.titleVal
            cell.ageLbl.text = data.type.ageVal
            cell.ageLbl.textColor = PPColor.identifierBlue
            cell.nameLbl.textColor = PPColor.identifierBlue
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear) {
                cell.bgView.backgroundColor = data.selected ? PPColor.bgYellow : PPColor.white
            } completion: { _ in}
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cvHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.9
        if indexPath.section == 0{
            return CGSize(width: width/3, height: 65)
        }else{
            return CGSize(width: width/2, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.vm?.modifyIdentifiers(index: indexPath.item, fromGender: indexPath.section == 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IdentifierReusableView", for: indexPath) as! IdentifierReusableView
            view.headerLbl.text = indexPath.section == 0 ? "How do you identify?" : "What age group do you belong to?"
            return view
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath) as! IdentifierReusableView
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}



//MARK:- ViewModal Delegate Method(s)

extension IdentifierQuestionVC: IdentifierViewModalProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }

    func updatedSuccessfully() {
        if fromSettings{
            self.navigationController?.popViewController(animated: true)
            return
        }
        AppDelegate().setHomeScreen()
    }
    func showErrorMessage(message: String) {
        DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: KeyMessages.shared.kMsgOk, handlerOK: nil)
    }
}
