//
//  AllSponsorsListingVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 15/11/21.
//

import UIKit

class AllSponsorsListingVC: UIViewController {
    
    //Mark:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var vm: AllSponsorsListingVM?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.vm?.getSponsors()
    }
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "All Sponsors", showBack: true, alignMiddle: true, delegate: self, showAdd: true) { [weak self] in
            let vc = AddEditSponsorsVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.register(UINib(nibName: "AllSponsorsCell", bundle: nil), forCellReuseIdentifier: "AllSponsorsCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm =  AllSponsorsListingVM(delegate: self)
        vm?.sponsors.bind({ _ in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        })
    }
    
    
}
//MARK:- Nav Header Delegate Method(s)

extension AllSponsorsListingVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- TableView Delegate Datasource Method(s)
extension AllSponsorsListingVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.sponsors.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AllSponsorsCell", for: indexPath) as! AllSponsorsCell
        cell.selectionStyle = .none
        if let data = vm?.sponsors.value[indexPath.row]{
            cell.imgSponsors.setImage(with: data.sponsorImage)
            cell.nameLbl.text = data.sponsorName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] action, iPath in
            let vc = AddEditSponsorsVC.instantiate(fromAppStoryboard: .SuperAdmin)
            guard let obj = self?.vm?.sponsors.value[iPath.row] else {return}
            vc.editObj = obj
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return [edit]
    }
    
}

//MARK:- VIew Modal Delegate Method(s)
extension AllSponsorsListingVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
