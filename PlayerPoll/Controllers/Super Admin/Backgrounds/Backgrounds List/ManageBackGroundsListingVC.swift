//
//  ManageBackGroundsListingVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 15/11/21.
//

import UIKit

class ManageBackGroundsListingVC: UIViewController {

    //Mark:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var vm: ManageBackgroundsListVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.vm?.getBackgrounds()
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Manage Backgrounds", showBack: true, alignMiddle: true, delegate: self, showAdd: true) { [weak self] in
            let vc = ManageBackgroundsVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.register(UINib(nibName: "ManageBackgroundsListingCell", bundle: nil), forCellReuseIdentifier: "ManageBackgroundsListingCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm =  ManageBackgroundsListVM(delegate: self)
        vm?.backgrounds.bind({ _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        })
    }
    
}
//MARK:- Nav Header Delegate Method(s)

extension ManageBackGroundsListingVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- TableView Delegate Datasource Method(s)
extension ManageBackGroundsListingVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.backgrounds.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ManageBackgroundsListingCell", for: indexPath) as! ManageBackgroundsListingCell
        cell.selectionStyle = .none
        if let data = self.vm?.backgrounds.value[indexPath.row]{
            cell.backgroundLbl.text = data.bgName
            cell.imgBackgrounds.setImage(with: data.bgImage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] action, iPath in
            let vc = ManageBackgroundsVC.instantiate(fromAppStoryboard: .SuperAdmin)
            guard let obj = self?.vm?.backgrounds.value[iPath.row] else {return}
            vc.editObj = obj
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return [edit]
    }
}


//MARK:- VIew Modal Delegate Method(s)
extension ManageBackGroundsListingVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
