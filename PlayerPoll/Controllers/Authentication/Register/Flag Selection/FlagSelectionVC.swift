//
//  FlagSelectionVC.swift
//  PlayerPoll
//
//  Created by mac on 21/12/21.
//

import UIKit

class FlagSelectionVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var selectBtn: PPFlagSelectButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variable Declarations
    var flags:[FlagDetails] = []{
        didSet{
            if tableView != nil && selectBtn != nil{
                tableView.reloadData()
            }
        }
    }
    var selected:((FlagDetails)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        tableView.register(UINib(nibName: "FlagSelectionCell", bundle: nil), forCellReuseIdentifier: "FlagSelectionCell")
        tableView.delegate = self
        tableView.dataSource = self
        setSelectBtn()
    }
    
    func setSelectBtn(){
        let empty = flags.filter({$0.selected}).isEmpty
        selectBtn.isHidden = empty
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectFlagBtnAction(_ sender: PPFlagSelectButton) {
        if let first = self.flags.filter({$0.selected}).first{
            selected?(first)
        }
    }
    
}


//MARK:- TableView Delegate Datasource Method(s)
extension FlagSelectionVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlagSelectionCell", for: indexPath) as! FlagSelectionCell
        cell.selectionStyle = .none
        let data = flags[indexPath.row]
        cell.flagNameLbl.text = data.countryName
        cell.flagImageView.image = UIImage(named: data.imageName)
        cell.flagNameLbl.textColor = data.selected ? PPColor.white : PPColor.identifierBlue
        cell.bgView.backgroundColor = !data.selected ? PPColor.white : PPColor.identifierBlue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flags = self.flags.map({ flagObj in
            var mutObj = flagObj
            mutObj.selected = false
            return mutObj
        })
        self.flags[indexPath.row].selected = true
        setSelectBtn()
    }
    
}
