//
//  ChatListingVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 16/11/21.
//

import UIKit

class ChatListingVC: UIViewController {

    //Mark:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    //MARK:- Variable Declarations
    var vm: ChatListingVM?
    var dismissed: (()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Chats", showBack: true, alignMiddle: true, delegate: self)
        tableView.register(UINib(nibName: "ChatListingCell", bundle: nil), forCellReuseIdentifier: "ChatListingCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm = ChatListingVM(delegate: self)
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
    
    
    override func viewDidDisappear(_ animated: Bool) {
        dismissed?()
    }
   

}
//MARK:- Nav Header Delegate Method(s)
extension ChatListingVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension ChatListingVC : UITableViewDelegate , UITableViewDataSource {
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
            cell.unreadLbl.isHidden = data.messageCount.toIntVal() == 0
            cell.unreadCountLbl.isHidden = data.messageCount.toIntVal() == 0
            cell.unreadCountLbl.text = data.messageCount
            cell.lblDescription.font = data.messageCount.toIntVal() == 0  ? PPFont.codeProBold(size: 15) : PPFont.codeProExtraBold(size: 15)
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


//MARK:- ViewModal Delegate Datasource Method(s)
extension ChatListingVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
