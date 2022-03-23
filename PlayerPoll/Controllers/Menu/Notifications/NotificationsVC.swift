//
//  NotificationsVC.swift
//  PlayerPoll
//
//  Created by mac on 26/10/21.
//

import UIKit

protocol NotificationActivityResponse {
    func notificationActivityResponseData()
}

class NotificationsVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    //MARK:- Variable Declarations
    var vm: NotificationActivityVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Notifications", showBack: true, alignMiddle: true, delegate: self)
        tableView.register(UINib(nibName: "NotificationListCell", bundle: nil), forCellReuseIdentifier: "NotificationListCell")
        tableView.delegate = self
        tableView.dataSource = self
        vm = NotificationActivityVM(delegate: self)
        vm?.gerNotificationActivity()
        vm?.details.bind({ notifications in
            DispatchQueue.main.async {
                if notifications.isEmpty{
                    self.tableView.backgroundView = DesignHelper.createEmptyView(title: "No notifications found!")
                }else{
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
}

//MARK:- Nav Header Delegate Method(s)
extension NotificationsVC: NavHeaderDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension NotificationsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm?.details.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListCell", for: indexPath) as! NotificationListCell
        cell.selectionStyle = .none
        cell.topSeperatorLbl.isHidden = indexPath.row != 0
        if (vm?.details.value.indices.contains(indexPath.row) ?? false), let data = vm?.details.value[indexPath.row] {
            if data.getNotifType() == .chat{
                cell.notifTitleLbl.text = "You got a message from \(data.userName): \(data.datumDescription)"
            }else{
                cell.notifTitleLbl.text = data.datumDescription
            }
            cell.dateLbl.text = data.getCreationTime()
            cell.notifImageView.image = UIImage(named: data.getNotifImage())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let details = vm?.details.value, let lastPage = vm?.isLastPage{
            if details.count - 1 == indexPath.row && !lastPage{
                vm?.page += 1
                vm?.gerNotificationActivity()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let obj = self.vm?.details.value[indexPath.row] else {return}
        redirectNotification(obj: obj)
    }
    
    func redirectNotification(obj: Notifications){
        if obj.getNotifType() == .chat{
            let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
            vc.otherUser = obj.otherUserID
            vc.profileImage = obj.profileImage
            vc.name = obj.userName
            self.navigationController?.pushViewController(vc, animated: true)
        }else if obj.getNotifType() == .smart{
            let pollId = obj.detailsID
            appDelegate().setHomeScreen(pollId: pollId)
        }
    }
}

extension NotificationsVC: NotificationActivityResponse {
    func notificationActivityResponseData() {
        self.tableView.reloadData()
    }
}


extension NotificationsVC: UserNotificationVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
