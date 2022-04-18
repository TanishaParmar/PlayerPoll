//
//  SideMenuVC.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//


import UIKit
import SDWebImage
protocol GetUserProfileData {
    func getUserDetails(userDetails: Profile)
}

class SideMenuVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var streakLbl: PPAnalyticsLabel!
    @IBOutlet weak var rewardsLbl: PPAnalyticsLabel!
    @IBOutlet weak var bioLbl: PPAnalyticsLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileNameLbl: PPSideMenuProfileNameLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileShadowView: UIView!
    
    //MARK:- Variable Declarations
    var userProfileDetails: Profile?
    var vm:SideMenuVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vm?.getProfileData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disaapear")
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI() {
        profileShadowView.layer.standardShadow()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        tableView.delegate = self
        tableView.dataSource = self
        streakLbl.attributedText = DesignHelper.getStreakValue(points: 89)
        rewardsLbl.attributedText = DesignHelper.getPointsValue(points: 7540)
        vm = SideMenuVM(delegate: self)
        vm?.options.bind({ options in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        vm?.unReadNotifications.bind({ options in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        vm?.details.bind({ details in
            DispatchQueue.main.async {
                self.setProfileData(details: details)
            }
        })
        vm?.flagDetails.bind({ [weak self] details in
            guard let flagDetails = details else {return}
            self?.flagImageView.image = UIImage(named: flagDetails.imageName)
        })
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProfile), name: NSNotification.Name("refreshProfile"), object: nil)
    }
    
    @objc func reloadProfile(){
        vm?.getProfileData()
    }
    
    func setProfileData(details: Profile? = nil){
        if let userData = details{
            self.profileImageView.setImage(with: userData.profileImage) { err in
                self.profileImageView.image = UIImage(named: "appLogo")
                self.profileImageView.backgroundColor = .black
            }
            self.profileNameLbl.text = userData.getShortUserName()
            self.rewardsLbl.attributedText = DesignHelper.getPointsValue(points: userData.diamondPoints.toIntVal())
            self.streakLbl.attributedText = DesignHelper.getStreakValue(points: userData.thunderPoints.toIntVal())
            self.bioLbl.text = userData.bio
//            print(userData.bio)
//            self.vm?.addSuperAdmin()
            if details?.userRole == "2"{
                self.vm?.addSuperAdmin()
            } else {
                self.vm?.checkForContact()
            }
        }else{
            _ = [profileNameLbl,rewardsLbl,streakLbl].map({$0?.text = ""})
        }
    }
    
    //MARK:- Display User Data
    
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    
}

//MARK:- TableView Delegate Datasource Method(s)
extension SideMenuVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.options.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.selectionStyle = .none
        if let data = vm?.options.value[indexPath.row]{
            cell.settingLbl.text = data.rawValue
            cell.menuIconView.image = data.image
            cell.badgeImageView.isHidden = (data != .messages) ? true : !(vm?.unReadNotifications.value ?? false)
            cell.badgeImageView.isHidden = (data != .notifications) ? true : !(vm?.unReadNotifications.value ?? false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.vm?.options.value[indexPath.row] {
        case .listview:
            let vc = ListViewVC.instantiate(fromAppStoryboard: .Menu)
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .overCurrentContext
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        case .rewards:
            navigateToRewards()
        case .settings:
            let vc = UserSettingsVC.instantiate(fromAppStoryboard: .Menu)
            self.navigationController?.pushViewController(vc, animated: true)
        case .superadmin:
            let vc = SuperAdminOptionsVC.instantiate(fromAppStoryboard: .Menu)
            self.navigationController?.pushViewController(vc, animated: true)
        case .notifications:
            let vc = NotificationsVC.instantiate(fromAppStoryboard: .Menu)
            self.navigationController?.pushViewController(vc, animated: true)
        case .leaderboard:
            let vc = LeaderboardVC.instantiate(fromAppStoryboard: .Menu)
            self.navigationController?.pushViewController(vc, animated: true)
        case .messages:
            let vc = ChatListingVC.instantiate(fromAppStoryboard: .Menu)
            vc.dismissed = {
                self.vm?.getUnreadMessageCount()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case .contact:
            let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
            vc.otherUser = Globals.superAdminId
            vc.name = "Support"
            vc.fromSuperAdmin = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Kaali baito")
        }
    }
    
    func navigateToRewards(){
        self.vm?.getRewardsStatus(completion: { val in
            DispatchQueue.main.async { [weak self] in
                if val{
                    let vc = RewardsGainedVC.instantiate(fromAppStoryboard: .Menu)
                    vc.totalPoints = self?.vm?.details.value?.diamondPoints ?? ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = RewardsDescVC.instantiate(fromAppStoryboard: .Menu)
                    vc.totalPoints = self?.vm?.details.value?.diamondPoints ?? ""
                    vc.points = self?.vm?.details.value?.diamondPoints ?? ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    
}
//MARK:- view modal Delegate Method(s)

extension SideMenuVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}


