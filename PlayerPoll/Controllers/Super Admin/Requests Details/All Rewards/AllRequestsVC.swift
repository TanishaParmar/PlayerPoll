//
//  AllRequestsVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 12/11/21.
//

import UIKit

class AllRequestsVC: UIViewController {

    
    //Mark:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var vm: AllRequestsVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:- Configuring UI Method(s)
    
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Requests", showBack: true, alignMiddle: true, delegate: self)
        tableView.register(UINib(nibName: "AllRequestsCell", bundle: nil), forCellReuseIdentifier: "AllRequestsCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm = AllRequestsVM(delegate: self)
        vm?.getRewards()
        vm?.rewards.bind({ rewards in
            DispatchQueue.main.async {
                if rewards.isEmpty{
                    self.tableView.backgroundView = DesignHelper.createEmptyView(title: "No requests history found!")
                }else{
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            }
        })
    }

    

}
//MARK:- Nav Header Delegate Method(s)

extension AllRequestsVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- TableView Delegate Datasource Method(s)
extension AllRequestsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.rewards.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllRequestsCell", for: indexPath) as! AllRequestsCell
        cell.selectionStyle = .none
        if let data = vm?.rewards.value[indexPath.row]{
            cell.nameLbl.text = data.userName
            cell.amountLbl.text = data.rewardPoints
            cell.dateLbl.text = DateFormatterManager.shared.getStringDateFormat(format: "dd MMM yyyy", stamp: data.created)
            cell.requestView.backgroundColor = data.isPayment == "1" ? #colorLiteral(red: 0.03411292657, green: 0.2908475399, blue: 0.6796378493, alpha: 1) : #colorLiteral(red: 0.05481668562, green: 0.1200794801, blue: 0.5319060683, alpha: 1)
            cell.statusImg.image = data.isPayment == "1" ? #imageLiteral(resourceName: "unRead") : #imageLiteral(resourceName: "read")
        }
        cell.selectionStyle = .none

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestsDetailVC.instantiate(fromAppStoryboard: .SuperAdmin)
        vc.obj = vm?.rewards.value[indexPath.row]
        vc.refreshData = {
            self.vm?.getRewards()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- VIew Modal Delegate Method(s)
extension AllRequestsVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
