//
//  SuperAdminOptionsVC.swift
//  PlayerPoll
//
//  Created by mac on 25/10/21.
//

import UIKit
import Alamofire
class SuperAdminOptionsVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var options = SuperAdminOptions.allCases
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI() {
        PPCustomHeader.setNavHeaderView(view: navView, title: "Super Admin", showBack: true, alignMiddle: true, delegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
}

//MARK:- Nav Header Delegate Method(s)
extension SuperAdminOptionsVC: NavHeaderDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension SuperAdminOptionsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let data = options[indexPath.row]
        cell.textLabel?.text = data.rawValue
        cell.textLabel?.textColor = PPColor.white
        cell.textLabel?.font = PPFont.codeProBold(size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch options[indexPath.row] {
        case .requests:
            let vc = AllRequestsVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .manageSponsors:
            let vc = AllSponsorsListingVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .manageBackgrounds:
            let vc = ManageBackGroundsListingVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case.analytics:
            let vc = AnalyticsListingVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case.createPoll:
            let vc = SuperAdminPollsListingVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .support:
            let vc = SupportChatsListingVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .notifications:
            let vc = SendMassPushVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .categories:
            let vc = CategoriesListVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        case .smartNotifications:
            print("do nothing")
            let vc = SendSmartNotificationVC.instantiate(fromAppStoryboard: .SuperAdmin)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
