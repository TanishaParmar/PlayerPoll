//
//  SelectPollVC.swift
//  PlayerPoll
//
//  Created by Phani's MacBook Pro on 19/01/22.
//

import UIKit

class SelectPollVC: UIViewController {
    //MARK: IBOutlet(s)
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variable Declarations
    var polls: [SuperAdminPolls] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    var pollSelected:((SuperAdminPolls)->Void)?
    
    //MARK:- View Controller LifeCycle Method(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        tableView.register(UINib(nibName: "PollSelectCell", bundle: nil), forCellReuseIdentifier: "PollSelectCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    
    //MARK: IBAction Method(s)
    
    
}

//MARK: TableView Delegate Method(s)

extension SelectPollVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PollSelectCell", for: indexPath) as! PollSelectCell
        cell.selectionStyle = .none
        let data = polls[indexPath.row]
        cell.nameLbl.text = data.pollText
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pollSelected?(polls[indexPath.row])
    }
}
