//
//  EditPollListingVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 17/11/21.
//

import UIKit

class SuperAdminPollsListingVC: UIViewController {
    
    // Mark:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var vm: SuperAdminPollsListingVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vm?.getAllPolls()
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Polls", showBack: true, alignMiddle: true, delegate: self, showAdd: true) { [weak self] in
            let vc = CreatePollVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.register(UINib(nibName: "PollListingCell", bundle: nil), forCellReuseIdentifier: "PollListingCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm = SuperAdminPollsListingVM(delegate: self)
        vm?.polls.bind({ _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}
//MARK:- Nav Header Delegate Method(s)

extension SuperAdminPollsListingVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension SuperAdminPollsListingVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.polls.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PollListingCell", for: indexPath) as! PollListingCell
        cell.selectionStyle = .none
        if let data = self.vm?.polls.value[indexPath.row]{
            cell.lblName.text = data.pollText
            cell.lblCategoryId.text = data.catID.getCategory().rawValue
            cell.lblTime.text = data.getCreationTime()
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] action, iPath in
            let vc = CreatePollVC.instantiate(fromAppStoryboard: .SuperAdmin)
            vc.fromEdit = true
            vc.pollObj = self?.vm?.polls.value[indexPath.row]
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return [edit]
    }
}


//MARK:- VIew Modal Delegate Method(s)
extension SuperAdminPollsListingVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
