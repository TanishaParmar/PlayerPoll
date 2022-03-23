//
//  CategoriesListVC.swift
//  PlayerPoll
//
//  Created by mac on 22/12/21.
//


import UIKit

class CategoriesListVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variable Declarations
    var vm: CategoryListVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Categories", showBack: true, alignMiddle: true, delegate: self, showAdd: true) { [weak self] in
            let vc = AddCategoryVC.instantiate(fromAppStoryboard: .SuperAdmin)
            vc.addedSuccessfully = { [weak self] in
                self?.vm?.getAllCategories()
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.register(UINib(nibName: "CategoriesListingCell", bundle: nil), forCellReuseIdentifier: "CategoriesListingCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm = CategoryListVM(delegate: self)
        vm?.getAllCategories()
        vm?.categories.bind({ catData in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
}


//MARK:- ViewModal Delegate Datasource Method(s)
extension CategoriesListVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}

//MARK:- Nav Header Delegate Method(s)
extension CategoriesListVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- TableView Delegate Datasource Method(s)
extension CategoriesListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.categories.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesListingCell", for: indexPath) as! CategoriesListingCell
        cell.selectionStyle = .none
        if let data = self.vm?.categories.value[indexPath.row]{
            cell.catNameLbl.text = data.title.uppercased()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] action, iPath in
            let vc = AddCategoryVC.instantiate(fromAppStoryboard: .SuperAdmin)
            vc.addedSuccessfully = { [weak self] in
                self?.vm?.getAllCategories()
            }
            vc.catData = self?.vm?.categories.value[indexPath.row]
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return [edit]
    }
    
}
