//
//  ProfileVC.swift
//  PlayerPoll
//
//  Created by mac on 25/10/21.
//


import UIKit

class ProfileVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var catTableView: UITableView!
    @IBOutlet weak var catHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioLbl: PPProfileSubTitleLabel!
    @IBOutlet weak var rewardsLbl: PPProfileSubTitleLabel!
    @IBOutlet weak var pointsLbl: PPProfileSubTitleLabel!
    @IBOutlet weak var rankLbl: PPProfileRankLabel!
    @IBOutlet weak var nameLbl: PPProfileNameLabel!
    @IBOutlet weak var messageImageView: UIImageView!
    //MARK:- Variable Declarations
    var vm: ProfileVM?
    var id = ""
    var categoryData = Categories.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.catHolderView.fadeOut()
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI() {
        vm = ProfileVM(delegate: self, id: id)
//        PPCustomHeader.setNavHeaderView(view: navView, title: "Profile", showBack: true, alignMiddle: true, delegate: self)
        
        PPCustomHeader.setProfileNavHeaderView(view: navView, title: "Profile", showBack: true, alignMiddle: true, delegate: self, showSetting: true) {
            print("call setting methods")
            let vc = UserSettingsVC.instantiate(fromAppStoryboard: .Menu)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.register(UINib(nibName: "ProfilePollsCell", bundle: nil), forCellReuseIdentifier: "ProfilePollsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        catTableView.register(UINib(nibName: "ListViewCatCell", bundle: nil), forCellReuseIdentifier: "ListViewCatCell")
        catTableView.delegate = self
        catTableView.dataSource = self
        catHolderView.alpha = 0
        vm?.loadProfileData()
        vm?.details.bind({ [weak self] profileData in
            self?.updateProfileData(data: profileData)
        })
        vm?.polls.bind({ polls in
            DispatchQueue.main.async {
                if polls.isEmpty{
                    self.tableView.backgroundView = DesignHelper.createEmptyView(title: "No polls found!")
                }else{
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            }
        })
        vm?.flagDetails.bind({ [weak self] details in
            guard let flagDetails = details else {return}
            self?.flagImageView.image = UIImage(named: flagDetails.imageName)
        })
    }
    
    func updateProfileData(data: UserProfile? = nil){
        if let obj = data{
            nameLbl.text = obj.userName
            bioLbl.text = obj.bio
            rankLbl.text = obj.userRank
            messageImageView.isHidden = obj.userID == Globals.userId
            self.profileImageView.setImage(with: obj.profileImage) { err in
                self.profileImageView.image = UIImage(named: "appLogo")
                self.profileImageView.backgroundColor = .black
            }
            self.rewardsLbl.text = obj.thunderPoints
            self.pointsLbl.text = obj.diamondPoints
        }else{
            _ = [nameLbl,bioLbl,rankLbl,pointsLbl,rewardsLbl].map({$0?.text = ""})
        }
    }
    
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    @IBAction func messageBtnAction(_ sender: UIButton) {
        if let details = vm?.details.value{
            guard details.userID != Globals.userId else {return}
            let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
            vc.otherUser = details.userID
            vc.profileImage = details.profileImage
            vc.name = details.userName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func filterBtnAction(_ sender: UIButton) {
        self.catHolderView.fadeIn()
    }
    
}

//MARK:- Nav Header Delegate Method(s)
extension ProfileVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.catTableView{
            return categoryData.count
        }
        return vm?.polls.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.catTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCatCell", for: indexPath) as! ListViewCatCell
            cell.selectionStyle = .none
            cell.catLbl.text = categoryData[indexPath.row].rawValue
            cell.catLbl.textColor = categoryData[indexPath.row].color
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePollsCell", for: indexPath) as! ProfilePollsCell
        cell.selectionStyle = .none
        if let obj = vm?.polls.value[indexPath.row]{
            cell.catLbl.text = obj.categoryDetails.title.uppercased()
            cell.contentView.backgroundColor = obj.categoryDetails.getCatColor()
            cell.pollLbl.text = obj.pollText
            cell.dateLbl.text = obj.getCreationDateString(format: "dd MMM yyyy")
            cell.dateLbl.backgroundColor = obj.userAnswered() ? PPColor.pointsGreen : PPColor.bgYellow
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == catTableView{
            return 40
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == catTableView{
            return 40
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == catTableView{
            self.catHolderView.fadeOut()
            self.vm?.getAllPolls(catId: categoryData[indexPath.row].getID)
        }else{
            if let pollId = self.vm?.polls.value[indexPath.row].pID{
                appDelegate().setHomeScreen(pollId: pollId)
            }
        }
    }
    
}

//MARK:- VIew Modal Delegate Method(s)
extension ProfileVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
