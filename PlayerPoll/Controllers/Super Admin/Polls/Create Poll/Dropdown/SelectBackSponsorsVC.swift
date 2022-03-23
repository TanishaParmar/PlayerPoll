//
//  SelectBackSponsorsVC.swift
//  PlayerPoll
//
//  Created by mac on 25/11/21.
//


import UIKit

class SelectBackSponsorsVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variable Declarations
    var isBackground = false
    var backgrounds:[Backgrounds] = []
    var sponsors:[Sponsors] = []
    var sponsorTapped:((Sponsors)->Void)?
    var backgroundTapped:((Backgrounds)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        tableView.register(UINib(nibName: "SelectBGSponsorCell", bundle: nil), forCellReuseIdentifier: "SelectBGSponsorCell")
        tableView.delegate = self
        tableView.dataSource = self
        let height = isBackground ? (backgrounds.count * 40) : (sponsors.count * 40)
        heightConstraint.constant = (Double(UIScreen.main.bounds.height) - 100) < Double(height) ? (UIScreen.main.bounds.height - 100) : CGFloat(height)
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    
}

//MARK:- TableView Delegate Datasource Method(s)
extension SelectBackSponsorsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isBackground ? backgrounds.count : sponsors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBGSponsorCell", for: indexPath) as! SelectBGSponsorCell
        cell.selectionStyle = .none
        if isBackground{
            let data = backgrounds[indexPath.row]
            cell.selectBGNameLbl.text = data.bgName
        }else{
            let data = sponsors[indexPath.row]
            cell.selectBGNameLbl.text = data.sponsorName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isBackground{
            backgroundTapped?(backgrounds[indexPath.row])
        }else{
            sponsorTapped?(sponsors[indexPath.row])
        }
    }
    
    
}
