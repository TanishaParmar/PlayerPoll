//
//  UnAnsweredPollCell.swift
//  PlayerPoll
//
//  Created by mac on 20/10/21.
//

import UIKit

class HomePollCell: UITableViewCell {
    @IBOutlet weak var pollstersBtn: UIButton!
    @IBOutlet weak var tvWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var inProgressLbl: UILabel!
    var poll: HomePolls?
    var pollAnswered:((HomePolls,String)->Void)?
    var convertedString = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: HomePolls){
        self.poll = data
        pollstersBtn.isHidden = !data.userAnswered() ? true : (data.submitAnswerUserDetails.count >= 30 ? false : true)
        inProgressLbl.isHidden = !data.userAnswered() ? true : (data.submitAnswerUserDetails.count < 30 ? false : true)
        answersTableView.register(UINib(nibName: "UnAnsweredOptionCell", bundle: nil), forCellReuseIdentifier: "UnAnsweredOptionCell")
        answersTableView.register(UINib(nibName: "AnsweredOptionCell", bundle: nil), forCellReuseIdentifier: "AnsweredOptionCell")
        answersTableView.delegate = self
        answersTableView.dataSource = self
        answersTableView.separatorStyle = .none
        questionLbl.text = data.pollText
        answersTableView.reloadData()
        if data.userAnswered(){
            if let finalWidth = data.optionsDetails.map({$0.options.width(withConstrainedHeight: 18) + $0.percentage.width(withConstrainedHeight: 18)}).max(){
                tvWidthConstraint.constant = finalWidth + 85
            }
        }else{
            if let finalWidth = data.optionsDetails.map({$0.options.width(withConstrainedHeight: 18)}).max(){
                tvWidthConstraint.constant = finalWidth + 35.0
            }
        }
        tvHeightConstraint.constant = CGFloat(data.optionsDetails.count) * 58.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- TableView Delegate Datasource Method(s)
extension HomePollCell: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll?.optionsDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = poll?.optionsDetails[indexPath.row], let poll = self.poll else {return UITableViewCell()}
        if poll.userAnswered(){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnsweredOptionCell", for: indexPath) as! AnsweredOptionCell
            cell.selectionStyle = .none
            cell.optionLbl.text = data.options
            cell.percLbl.text = String(format: "%.2f", data.percentage.toDoubleVal()) + "%"
            cell.bgView.backgroundColor = data.optionID == poll.submitOptionID ? PPColor.bgYellow : PPColor.white
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnAnsweredOptionCell", for: indexPath) as! UnAnsweredOptionCell
        cell.selectionStyle = .none
        cell.answerLbl.text = data.options
        cell.bgView.backgroundColor =  PPColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let poll = self.poll else {return}
        if !poll.userAnswered(){
            pollAnswered?(poll, poll.optionsDetails[indexPath.row].optionID)
        }
    }
    
}
