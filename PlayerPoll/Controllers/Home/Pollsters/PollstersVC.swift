//
//  PollstersVC.swift
//  PlayerPoll
//
//  Created by mac on 21/10/21.
//

import UIKit

class PollstersVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionLbl: PPPollstersQuestionLabel!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var vm: PollstersVM?
    var poll:HomePolls?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Pollsters", showBack: true, alignMiddle: true, delegate: self)
        tableView.register(UINib(nibName: "PollstersCell", bundle: nil), forCellReuseIdentifier: "PollstersCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        guard let poll = self.poll else {return}
        questionLbl.text = poll.pollText
        vm = PollstersVM(delegate: self, data: poll.submitAnswerUserDetails)
        vm?.pollsters.bind({ val in
            self.tableView.reloadData()
        })
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
}

//MARK:- Nav Header Delegate Method(s)
extension PollstersVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension PollstersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.pollsters.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollstersCell", for: indexPath) as! PollstersCell
        cell.selectionStyle = .none
        if let data = vm?.pollsters.value[indexPath.row]{
            cell.profileImageView.setImageWithPlaceHolder(with: data.profileImage)
            cell.messageImgView.isHidden = data.userID == Globals.userId
            cell.messageBtn.tag = indexPath.row
            cell.messageBtn.addTarget(self, action: #selector(messageTapped(sender:)), for: .touchUpInside)
            cell.nameLbl.text = data.userID == Globals.userId ? "You" : data.userName
            cell.pointsLbl.text = data.diamondPoints
        }
        return cell
    }
    
    @objc func messageTapped(sender: UIButton){
        if let data = vm?.pollsters.value[sender.tag]{
            if data.userID == Globals.userId{
                return
            }
            let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
            vc.otherUser = data.userID
            vc.profileImage = data.profileImage
            vc.name = data.userName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = vm?.pollsters.value[indexPath.row] else {return}
        redirectToProfile(id: data.userID)
    }
    
    func redirectToProfile(id: String){
        let vc = ProfileVC.instantiate(fromAppStoryboard: .Menu)
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK:- ViewModal Delegate Datasource Method(s)
extension PollstersVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
