//
//  RewardsDescVC.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit

class RewardsDescVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var currentTotalLbl: UILabel!
    @IBOutlet weak var totalPtsLbl: UILabel!
    //MARK:- Variable Declarations
    var points: String = ""
    var totalPoints: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Rewards", showBack: true, delegate: self)
        totalPtsLbl.text = totalPoints
        currentTotalLbl.text = points.toIntVal() > 7000 ? "Your current total is \(points) points. Keep polling! Almost there!" : "Your current total is \(points) points. Keep polling!"
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func supportBtnAction(_ sender: UIButton) {
        guard Globals.userId != Globals.superAdminId else {return}
        let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
        vc.otherUser = Globals.superAdminId
        vc.name = "Support"
        vc.fromSuperAdmin = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Nav Header Delegate Method(s)
extension RewardsDescVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
