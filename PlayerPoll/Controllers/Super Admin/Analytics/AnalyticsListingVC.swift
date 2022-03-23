//
//  AnalyticsListingVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 16/11/21.
//

import UIKit

class AnalyticsListingVC: UIViewController {
    // Mark:- IBOutlets
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var analyticsCollectionView: UICollectionView!
    
    //MARK:- Variable Declarations
    var vm: AnalyticsListingVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        PPCustomHeader.setNavHeaderView(view: navView, title: "Analytics", showBack: true, alignMiddle: true, delegate: self)
        analyticsCollectionView.register(UINib(nibName: "AnalyticsListingCell", bundle: nil), forCellWithReuseIdentifier: "AnalyticsListingCell")
        analyticsCollectionView.delegate = self
        analyticsCollectionView.dataSource = self
        vm = AnalyticsListingVM(delegate: self)
        vm?.getAnalytics()
        vm?.data.bind({ _ in
            DispatchQueue.main.async {
                self.analyticsCollectionView.reloadData()
            }
        })
    }
    
    
}
//MARK:- Nav Header Delegate Method(s)

extension AnalyticsListingVC: NavHeaderDelegate{
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate Datasource Method(s)
extension AnalyticsListingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm?.data.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalyticsListingCell", for: indexPath) as! AnalyticsListingCell
        if let data = vm?.data.value[indexPath.item]{
            cell.lblTitle.text = data.value
            cell.lblDetails.text = data.type.rawValue
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size - 18 , height: size - 18 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    
}


//MARK:- VIew Modal Delegate Method(s)
extension AnalyticsListingVC: ProgressHUDProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}
