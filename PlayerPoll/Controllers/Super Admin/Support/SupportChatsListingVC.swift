//
//  SupportChatsListingVC.swift
//  PlayerPoll
//
//  Created by MyMac on 11/24/21.
//

import UIKit

class SupportChatsListingVC: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var vm: SupportChatsListingVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Configuring UI Method(s)
    func configureUI() {
        PPCustomHeader.setNavHeaderView(view: navView, title: "Support", showBack: true, alignMiddle: true, delegate: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChatListingCell", bundle: nil), forCellReuseIdentifier: "ChatListingCell")
        vm = SupportChatsListingVM(delegate: self)
        vm?.getUserMessages()
        vm?.userChats.bind { chats in
            DispatchQueue.main.async {
                if (chats.isEmpty){
                    self.tableView.backgroundView = DesignHelper.createEmptyView(title: "No chats found!")
                }else{
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
}

//MARK: - TableView Delegate Datasource Method(s)
extension SupportChatsListingVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.userChats.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ChatListingCell", for: indexPath) as! ChatListingCell
        cell.selectionStyle = .none
        if let data = vm?.userChats.value[indexPath.row]{
            cell.imgProfile.setImageWithPlaceHolder(with: data.profileImage)
            cell.lblName.text = data.userName
            cell.lblDescription.text = data.lastMessage
            cell.lblTime.text = DesignHelper.returnMessagesTime(timeString: data.lastMessageTime)
            cell.imgProfile.setRounded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = vm?.userChats.value[indexPath.row] else {return}
        let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
        vc.otherUser = data.otherUserID
        vc.profileImage = data.profileImage
        vc.name = data.userName
        vc.dismissedChat = {
            self.vm?.page = 1
            self.vm?.getUserMessages()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = self.vm?.userChats.value.count, let lastPage = vm?.isLastPage else {return}
        if indexPath.row == count - 1 && !lastPage{
            self.vm?.getUserMessages()
        }
    }
}

//MARK: - Nav Header Delegate Method(s)
extension SupportChatsListingVC: NavHeaderDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- ViewModal Delegate Datasource Method(s)
extension SupportChatsListingVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
