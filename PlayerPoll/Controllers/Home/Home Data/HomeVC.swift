//
//  HomeVC.swift
//  PlayerPoll
//
//  Created by mac on 18/10/21.
//

import UIKit
import LGSideMenuController
//import GoogleMobileAds
import SwiftGoogleTranslate
import Branch
class HomeVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var sponsorImageView: UIImageView!
    
    @IBOutlet weak var holderView: UIView!
//    @IBOutlet weak var adverView: UIView!
    @IBOutlet weak var pollBgImageView: UIImageView!
    @IBOutlet weak var muteUnmuteImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLbl: PPHomeAnalyticsLabel!
    @IBOutlet weak var quesPointsLbl: PPHomePointsLabel!
    @IBOutlet weak var pointsLbl: PPHomeAnalyticsLabel!
    @IBOutlet weak var streakLbl: PPHomeAnalyticsLabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var muteUnmuteButton: UIButton!
    //MARK:- Variable Declarations
    var vm: HomeVM?
//    var bannerView: GADBannerView!
    var pollId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI() {
        vm = HomeVM(delegate: self)
        print(pollId)
        vm?.getAllPolls(pollId: pollId)
        vm?.polls.bind({ polls in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        vm?.currentPoll.bind { [weak self] poll in
            guard let self = self else {return}
            if let poll = poll{
                DispatchQueue.main.async {
                    self.sponsorImageView.setSponsor(url: poll.sponsorDetails.sponsorImage)
                    self.pollBgImageView.setImageWithBGPlaceHolder(with: poll.backgroundDetails.bgImage)
                    DesignHelper.setQuestionPoints(lbl: self.quesPointsLbl, lblCategory: self.categoryLbl, poll: poll)
                }
            }
        }
        vm?.profile.bind({ [weak self] prData in
            DispatchQueue.main.async {
                self?.streakLbl.attributedText = DesignHelper.getStreakValue(points: prData?.thunderPoints.toIntVal() ?? 0)
                self?.pointsLbl.attributedText = DesignHelper.getPointsValue(points: prData?.diamondPoints.toIntVal() ?? 0)
            }
        })
        tableView.register(UINib(nibName: "HomePollCell", bundle: nil), forCellReuseIdentifier: "HomePollCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        /*let adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.width, height: 50))
        bannerView = GADBannerView(adSize: adSize)
        bannerView.delegate = self
        addBannerViewToView(bannerView) */
        self.sideMenuController?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(langChanged), name: NSNotification.Name(rawValue: NSLocale.currentLocaleDidChangeNotification.rawValue), object: nil)
    }
    
    @objc func langChanged(){
        self.vm?.currentPoll.value = self.vm?.currentPoll.value.map({ pollObj in
            var mutObj = pollObj
            mutObj.convertedString = nil
            return mutObj
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sideMenuController?.delegate = self
    }
    
    @objc func shareButtonAction(sender : UIButton) {
        guard let waterImage = self.holderView.takeScreenshot().addWaterMark() else {return}
        DataManager.createContentDeepLink(title: kAppName, type: "Post", OtherId: self.vm?.currentPoll.value?.pID ?? "") { urlStr in
            if let url = URL(string: urlStr ?? "") {
                print(urlStr)
//                let objectsToShare = ["Hey, look at this post.",url,waterImage] as [Any]
                let objectsToShare = ["Trending now on PlayerPoll",waterImage,url] as [Any]
                DataManager.presentShare(objectsToShare: objectsToShare, vc: self)
            }
        }
    }
    
    func createContentDeepLink(title: String,type: String,OtherId: String, description: String, image: String?,link: String,completion: @escaping (String?) -> ()) {
        let buo = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        buo.canonicalUrl = "http://playerpoll"
        buo.publiclyIndex = false
        buo.locallyIndex = false
        buo.title = title
        buo.contentDescription = description
        if image != "" {
            buo.imageUrl = image
        }
        let linkLP: BranchLinkProperties =  BranchLinkProperties()
        linkLP.addControlParam("link", withValue: link)
        linkLP.addControlParam("OtherID", withValue: OtherId)
        linkLP.addControlParam("type", withValue: type)
        linkLP.addControlParam("environment", withValue: DataManager.returnEnv().rawValue)
        buo.getShortUrl(with: linkLP) { (url, error) in
            if error == nil {
                completion(url)
            }
            else {
                print(error)
            }
        }
        print(linkLP)
    }
  
    
    //MARK:- add Banner to view
  /*  func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.adUnitID = "ca-app-pub-3923747521837403/2192421670"
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        adverView.addSubview(bannerView)
        let guide = adverView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
        ])
    }*/
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func listViewBtnAction(_ sender: UIButton) {
        let vc = ListViewVC.instantiate(fromAppStoryboard: .Menu)
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func muteUnmuteButtonAction(_ sender: Any) {
        MediaPlayerManager.shared.puase()
        muteUnmuteButton.isSelected = !muteUnmuteButton.isSelected
        if muteUnmuteButton.isSelected {
            print("mute")
            muteUnmuteImgView.image = UIImage(named: "mute")
            MediaPlayerManager.shared.puase()
        } else {
            print("unmute")
            muteUnmuteImgView.image = UIImage(named: "unmute")
            MediaPlayerManager.shared.resume()
        }
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        if let _ = tableView.visibleCells.first as? HomePollCell{
//            createContentDeepLink(title: "player poll", type: "LiveStream", OtherId: "28", description: "Hey, look at this post.", image: "https://youtu.be/7WWgl4GHHuI", link: "https://youtu.be/7WWgl4GHHuI") { urlStr in
//    //            let urlS = URL(string: "candace://")
//
//                if let url = URL(string: urlStr ?? "") {
//                    print(urlStr)
//                    let objectsToShare = ["Hey, look at this post.",url] as [Any]
////                    AFWrapperClass.presentShare(objectsToShare: objectsToShare, vc: self)
//                    DataManager.presentShare(objectsToShare: objectsToShare, vc: self)
//                }
//            }
            shareButtonAction(sender: shareBtn)
//            if let waterImage = self.holderView.takeScreenshot().addWaterMark(){
//                DataManager.presentShare(objectsToShare: [waterImage], vc: self)
//            }
        }
    }
    
    @IBAction func menuBtnAction(_ sender: UIButton) {
        self.sideMenuController?.showLeftView(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name("refreshProfile"), object: nil)
        })
    }
    
    @IBAction func translateBtnAction(_ sender: UIButton) {
        if let cell = tableView.visibleCells.first as? HomePollCell, let iPath = tableView.indexPath(for: cell), let poll = vm?.polls.value[iPath.row], let deviceLan = Locale.preferredLanguages.first, let range = deviceLan.range(of: "-"){
            if !(poll.convertedString ?? "").isEmpty {
                cell.questionLbl.text = poll.convertedString ?? ""
                return
            }
            let targetLan = deviceLan[..<range.lowerBound]
            SwiftGoogleTranslate.shared.detect(poll.pollText) { detections, err in
                var lan = "en"
                for detection in detections ?? []{
                    lan = detection.language
                }
                if lan == String(targetLan){
                    return
                }
                SwiftGoogleTranslate.shared.translate(poll.pollText, String(targetLan), lan) { res, err in
                    guard let resString = res else {return}
                    if resString == poll.pollText{
                        return
                    }
                    self.vm?.polls.value[iPath.row].convertedString = resString
                    DispatchQueue.main.async {
                        
                        cell.questionLbl.text = resString
                    }
                }
            }
        }
    }
    
    
}


//MARK:- TableView Delegate Datasource Method(s)
extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.polls.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePollCell", for: indexPath) as! HomePollCell
        cell.selectionStyle = .none
        if let data = vm?.polls.value[indexPath.row] {
            cell.configureCell(data: data)
            if indexPath.row == 0 {
                if muteUnmuteButton.isSelected {
                    MediaPlayerManager.shared.stop()
                } else {
                    MediaPlayerManager.shared.stop()
                    MediaPlayerManager.shared.play(withURL: data.categoryDetails.audioFile)
                }
            }
        }
        if indexPath.row == 0 {
            self.vm?.currentPoll.value = vm?.polls.value[indexPath.row]
            if let pollId = self.vm?.currentPoll.value?.pID{
                self.vm?.updatePollView(pollId: pollId)
            }
        }
        cell.pollstersBtn.tag = indexPath.row
        cell.pollstersBtn.addTarget(self, action: #selector(redirectToPollsters(sender:)), for: .touchUpInside)
        cell.pollAnswered = { [weak self] poll, option in
            //Answer poll api
            self?.vm?.submitAnswer(optionId: option, pollId: poll.pID)
            DispatchQueue.main.async {
                guard let url = self?.vm?.getRelatedCategoryUrl(catId: poll.catID) else {return}
                if self?.muteUnmuteButton.isSelected == true {
                    MediaPlayerManager.shared.stop()
                } else {
                    MediaPlayerManager.shared.stop()
                    MediaPlayerManager.shared.play(withURL: url)
                }
            }
        }
        return cell
    }
    
    @objc func redirectToPollsters(sender: UIButton){
        if let _ = vm?.polls.value.indices.contains(sender.tag){
            let vc = PollstersVC.instantiate(fromAppStoryboard: .Home)
            vc.poll = vm?.polls.value[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = tableView.visibleCells.first as? HomePollCell, let iPath = tableView.indexPath(for: cell){
            self.vm?.currentPoll.value = vm?.polls.value[iPath.row]
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = tableView.visibleCells.first as? HomePollCell, let iPath = tableView.indexPath(for: cell){
            if let pollId = vm?.polls.value[iPath.row].pID{
                self.vm?.updatePollView(pollId: pollId)
            }
            DispatchQueue.main.async {
                guard let poll = self.vm?.polls.value[iPath.row]else {return}
                if self.muteUnmuteButton.isSelected {
                    MediaPlayerManager.shared.stop()
                } else {
                    MediaPlayerManager.shared.stop()
                    MediaPlayerManager.shared.play(withURL: poll.categoryDetails.audioFile)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        if let details = vm?.polls.value, let lastPage = vm?.lastPage{
            if details.count - 1 == indexPath.row && !lastPage{
                vm?.getAllPolls()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}

//MARK:- ViewModal Delegate Datasource Method(s)
extension HomeVC: HomeVMProtocol{
    func showHideHUD(showVal: Bool) {
        if showVal{
            HUD.showHud()
        }else{
            HUD.hideHud()
        }
    }
}

/*
//MARK:- Banner Delegate  Method(s)
extension HomeVC: GADBannerViewDelegate{
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
        print("banner loaded")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}
*/

//MARK:- Side Menu Delegate Method(s)

extension HomeVC: LGSideMenuDelegate{
    func willShowLeftView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didShowLeftView(sideMenuController: LGSideMenuController) {
        print("refresh babu")
    }
    func didHideLeftView(sideMenuController: LGSideMenuController) {
        self.vm?.pageIndex = 1
        self.vm?.getAllPolls()
    }
    
    func willHideLeftView(sideMenuController: LGSideMenuController) {
        
    }
    
    func willShowRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didShowRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func willHideRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didHideRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func showAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
    
    }
    
    func hideAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func showAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func hideAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func didTransformRootView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        
    }
    
    func didTransformLeftView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        
    }
    
    func didTransformRightView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        
    }
    
}
