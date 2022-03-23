//
//  RequestsDetailVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 12/11/21.
//

import UIKit
import Alamofire
class RequestsDetailVC: UIViewController {
  
    //Mark:- IBOutlets
    @IBOutlet weak var currentPointsLbl: PPRequestWhiteLabel!
    @IBOutlet weak var paymentMethodLbl: PPRequestWhiteLabel!
    @IBOutlet weak var totalPointsLbl: PPRequestWhiteLabel!
    @IBOutlet weak var nameLbl: PPRequestWhiteLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var paidStatusLbl: PPRequestWhiteLabel!
    @IBOutlet weak var markAsPaidBtn: PPMarkPaidButton!
    //MARK:- Variable Declarations
    var obj: Rewards?
    var refreshData:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshData?()
    }
    
    //MARK:- Configuring UI Method(s)
    
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Requests", showBack: true, alignMiddle: true, delegate: self)
        tableView.register(UINib(nibName: "RequestsCell", bundle: nil), forCellReuseIdentifier: "RequestsCell")
        tableView.delegate = self
        tableView.dataSource = self
        configureDetails()
    }
    
    func configureDetails(){
        guard let reward = obj else {return}
        nameLbl.text = reward.userName
        totalPointsLbl.text = reward.totalRewardsPoints
        currentPointsLbl.text = reward.rewardPoints
        paymentMethodLbl.text = !reward.paypal.isEmpty ? "PayPal" : (!reward.upi.isEmpty ? "UPI" : "Venmo")
        paidStatusLbl.text = reward.isPayment == "1" ? "Paid" : ""
        paidStatusLbl.isHidden = reward.isPayment == "0"
        markAsPaidBtn.isHidden = reward.isPayment == "1"
    }
    
    func updatePaymentStatus() {
        if !Reachability.isConnectedToNetwork() {
            DisplayAlertManager.shared.displayAlert(animated: true, message: KeyMessages.shared.kNoInternet, okTitle: KeyMessages.shared.kNoInternet, handlerOK: nil)
        }
        guard let obj = self.obj else {return}
        let params = ["authToken":Globals.authToken,"userID":Globals.userId,"reqID":obj.reqID,"timeZone":TimeZone.current.identifier] as [String:AnyObject]
        let url = getFinalUrl(with: .updateRewardsRequest)
        HUD.showHud()
        DataManager.requestPOSTWithFormData(type: UpdateRewardResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String : Any]]()) { responseData, statusCode in
            print("data is =>",responseData)
            HUD.hideHud()
            if statusCode == 401{
                appDelegate().setLogoutScreen()
                return
            }
            self.obj = responseData.data
            DispatchQueue.main.async {
                self.configureDetails()
            }
        } failure: { error in
            HUD.hideHud()
            print(error)
        }
    }
    

    //MARK:- IBAction Method(s)
    @IBAction func markPaidBtnAction(_ sender: PPMarkPaidButton) {
        updatePaymentStatus()
    }
    
}

//MARK:- Nav Header Delegate Method(s)
extension RequestsDetailVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension RequestsDetailVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return obj?.rewardsHistry.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsCell", for: indexPath) as! RequestsCell
        cell.selectionStyle = .none
        if let data = obj?.rewardsHistry[indexPath.row]{
            cell.amountLbl.text = NSNumber(value: data.price.toIntVal()).getCurrency()
            cell.DateLbl.text = DateFormatterManager.shared.getStringDateFormat(format: "dd MMM yyyy", stamp: data.created)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
}
