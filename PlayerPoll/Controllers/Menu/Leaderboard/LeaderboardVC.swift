//
//  LeaderboardVC.swift
//  PlayerPoll
//
//  Created by mac on 26/10/21.
//


import UIKit

class LeaderboardVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var seperatorLbl: UILabel!
    @IBOutlet weak var thirdProfileImageView: UIImageView!
    @IBOutlet weak var secondProfileImageView: UIImageView!
    @IBOutlet weak var firstProfileImageView: UIImageView!
    @IBOutlet weak var firstImageHolderView: UIView!
    @IBOutlet weak var secondImageHolderView: UIView!
    @IBOutlet weak var thirdImageView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var posThreePointsLbl: UILabel!
    @IBOutlet weak var posThreeNameLbl: UILabel!
    @IBOutlet weak var posTwoPointsLbl: UILabel!
    @IBOutlet weak var posTwoNameLbl: UILabel!
    @IBOutlet weak var posOnePointsLbl: PPPollstersPointsLabel!
    @IBOutlet weak var posOneNameLbl: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var firstViewButton: UIButton!
    @IBOutlet weak var secondViewButton: UIButton!
    @IBOutlet weak var thirdViewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //MARK:- Variable Declarations
    var vm: LeaderboardVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI() {
        PPCustomHeader.setNavHeaderView(view: navView, title: "", showBack: true, alignMiddle: true, delegate: self)
        setSegmentUI()
        tableView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellReuseIdentifier: "LeaderboardCell")
        tableView.delegate = self
        tableView.dataSource = self
        segmentControl.addTarget(self, action: #selector(changeSegment(sender:)), for: .valueChanged)
        _ = [firstView,secondView,thirdView,firstImageHolderView,secondImageHolderView,thirdImageView].map({$0?.isHidden = true})
        vm = LeaderboardVM(delegate: self)
        vm?.getLeaderboard(with: "3")
        vm?.users.bind({ users in
            DispatchQueue.main.async { [weak self] in
                self?.setPlayerData(users: users)
                if users.isEmpty{
                    self?.tableView.backgroundView = DesignHelper.createEmptyView(title: "No user has polled today!")
                    self?.tableView.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.1450980392, blue: 0.631372549, alpha: 1)
                }else{
                    self?.tableView.backgroundColor = users.count <= 3 ? #colorLiteral(red: 0.06274509804, green: 0.1450980392, blue: 0.631372549, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self?.tableView.backgroundView = nil
                }
                self?.tableView.reloadData()
            }
        })
    }
    
    
    func setPlayerData(users: [Leaderboard]){
        if let first = users.first{
            _ = [firstView,firstImageHolderView].map({$0?.isHidden = false})
            posOneNameLbl.text = DesignHelper.getFirstName(name: first.userName)
            firstProfileImageView.setImageWithPlaceHolder(with: first.profileImage)
            posOnePointsLbl.text = first.diamondPoints
            firstViewButton.tag = Int(first.userID) ?? 0
            if users.indices.contains(1){
                let second = users[1]
                _ = [secondView,secondImageHolderView].map({$0?.isHidden = false})
                posTwoNameLbl.text = DesignHelper.getFirstName(name: second.userName)
                posTwoPointsLbl.text = second.diamondPoints
                secondProfileImageView.setImageWithPlaceHolder(with: second.profileImage)
                secondViewButton.tag = Int(second.userID) ?? 0
            }
            if users.indices.contains(2){
                let third = users[2]
                _ = [thirdView,thirdImageView].map({$0?.isHidden = false})
                posThreeNameLbl.text = DesignHelper.getFirstName(name: third.userName)
                posThreePointsLbl.text = third.diamondPoints
                thirdProfileImageView.setImageWithPlaceHolder(with: third.profileImage)
                thirdViewButton.tag = Int(third.userID) ?? 0
            }
            seperatorLbl.isHidden = false
        }else{
            _ = [firstView,secondView,thirdView,firstImageHolderView,secondImageHolderView,thirdImageView].map({$0?.isHidden = true})
            seperatorLbl.isHidden = true
        }
    }
    
    func setSegmentUI(){
        if #available(iOS 13.0, *) {
            segmentControl.backgroundColor = PPColor.white
            segmentControl.layer.borderColor = PPColor.white.cgColor
            segmentControl.selectedSegmentTintColor = PPColor.bgYellow
            segmentControl.layer.borderWidth = 1
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: PPColor.identifierBlue,.font:PPFont.codeProBold(size: 14)]
            segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
            let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: PPColor.identifierBlue,.font:PPFont.codeProBold(size: 14)]
            segmentControl.setTitleTextAttributes(selectedTextAttributes, for:.selected)
        }
    }
    
    func redirectToProfile(id: String){
        let vc = ProfileVC.instantiate(fromAppStoryboard: .Menu)
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc func changeSegment(sender: UISegmentedControl){
        self.vm?.page = 1
        if sender.selectedSegmentIndex == 0 {
            self.vm?.getLeaderboard(with: "3")
        } else if sender.selectedSegmentIndex == 1 {
            self.vm?.getLeaderboard(with: "1")
        }
        else if sender.selectedSegmentIndex == 2 {
            self.vm?.getLeaderboard(with: "2")
       }
//        self.vm?.getLeaderboard(with: sender.selectedSegmentIndex == 0 ? "3" : "2")
    }
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    @IBAction func firstViewButtonAction(_ sender: Any) {
        redirectToProfile(id: "\(firstViewButton.tag)")
    }
    
    @IBAction func secondViewButtonAction(_ sender: Any) {
        redirectToProfile(id: "\(secondViewButton.tag)")
    }
    
    @IBAction func thirdViewButtonAction(_ sender: Any) {
        redirectToProfile(id: "\(thirdViewButton.tag)")
    }
    
}

//MARK:- Nav Header Delegate Method(s)
extension LeaderboardVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension LeaderboardVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataColl = self.vm?.users.value.dropFirst(3) ?? []
        return dataColl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        cell.selectionStyle = .none
        let dataColl = (self.vm?.users.value.dropFirst(3) ?? []).map({$0})
//        if dataColl.indices.contains(indexPath.row){
            let data = dataColl[indexPath.row]
            cell.rankLbl.text = "\(indexPath.row+4)"
            cell.nameLbl.text = data.userName
            cell.profileImageView.setImageWithPlaceHolder(with: data.profileImage)
            cell.scoreLbl.text = data.diamondPoints
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let dataColl = (self.vm?.users.value.dropFirst(3) ?? []).map({$0}) else {return}
        let dataColl = (self.vm?.users.value.dropFirst(3) ?? []).map({$0})
        let data = dataColl[indexPath.row]
        redirectToProfile(id: data.userID)
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.vm?.users.value.dropFirst(3).count ?? 0
        if indexPath.row == count-1 && !(self.vm?.lastPage ?? true){
//            self.vm?.getLeaderboard(with: self.segmentControl.selectedSegmentIndex == 0 ? "3" : "2")
            if self.segmentControl.selectedSegmentIndex == 0 {
                self.vm?.getLeaderboard(with: "3")
            } else if self.segmentControl.selectedSegmentIndex == 1 {
                self.vm?.getLeaderboard(with: "1")
            }
            else if self.segmentControl.selectedSegmentIndex == 2 {
                self.vm?.getLeaderboard(with: "2")
           }
        }
    }
}

//MARK:- Viewmodal Delegate Method(s)

extension LeaderboardVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
