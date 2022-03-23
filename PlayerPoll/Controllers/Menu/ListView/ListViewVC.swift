//
//  ListViewVC.swift
//  PlayerPoll
//
//  Created by mac on 19/10/21.
//

import UIKit

class ListViewVC: UIViewController {
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var catHolderView: UIView!
    @IBOutlet weak var catTableView: UITableView!
    //MARK:- Variable Declarations
    var categoryData = Categories.allCases
    var vm: ListViewVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.catHolderView.fadeOut()
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        tableView.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: "ListViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        catTableView.register(UINib(nibName: "ListViewCatCell", bundle: nil), forCellReuseIdentifier: "ListViewCatCell")
        catTableView.delegate = self
        catTableView.dataSource = self
        catTableView.isScrollEnabled = true
        catHolderView.alpha = 0
        vm = ListViewVM(delegate: self)
        vm?.selectedCatId.bind({ catId in
            self.vm?.page = 1
            self.vm?.getAllPolls(catId: catId)
        })
        vm?.categories.bind({ catData in
            DispatchQueue.main.async {
                self.catTableView.reloadData()
            }
        })
        vm?.polls.bind({ polls in
            DispatchQueue.main.async {
                if polls.isEmpty{
                    self.tableView.backgroundView = DesignHelper.createEmptyView(title: "No polls found!")
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
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        self.catHolderView.fadeIn()
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension ListViewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.catTableView{
            return vm?.categories.value.count ?? 0
        }
        return vm?.polls.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.catTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCatCell", for: indexPath) as! ListViewCatCell
            cell.selectionStyle = .none
            if let data = vm?.categories.value[indexPath.row]{
                cell.catLbl.text = data.title.uppercased()
                cell.catLbl.textColor = data.getCatColor()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        cell.selectionStyle = .none
        if let obj = self.vm?.polls.value[indexPath.row]{
            cell.pollLbl.text = obj.pollText
            cell.catLbl.text = obj.categoryDetails.title.uppercased()
            cell.contentView.backgroundColor = obj.categoryDetails.getCatColor()
            cell.readImageView.image = obj.getReadStatusImage()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == catTableView{
            return 40
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == catTableView{
            return 40
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == catTableView {
            self.catHolderView.fadeOut()
            self.vm?.page = 1
            self.vm?.selectedCatId.value = self.vm?.categories.value[indexPath.row].catID ?? ""
        } else {
            if let pollId = self.vm?.polls.value[indexPath.row].pID {
                appDelegate().setHomeScreen(pollId: pollId)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            if let details = vm?.polls.value, let lastPage = vm?.isLastPage{
                if details.count - 1 == indexPath.row && !lastPage{
                    vm?.page += 1
                    vm?.getAllPolls(catId: self.vm?.selectedCatId.value ?? "")
                }
            }
        }
    }
    
}

//MARK:- View Modal Delegate Method(s)
extension ListViewVC: ListViewVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
    
    func showEmptyAlert(message: String) {
        //DisplayAlertManager.shared.displayAlert(animated: true, message: message, okTitle: "Ok", handlerOK: nil)
    }
}
