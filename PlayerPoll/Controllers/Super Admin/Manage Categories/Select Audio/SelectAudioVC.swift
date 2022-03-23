//
//  SelectAudioVC.swift
//  PlayerPoll
//
//  Created by mac on 30/12/21.
//

import UIKit
import AVKit
class SelectAudioVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectBtn: PPFlagSelectButton!
    
    //MARK:- Variable Declarations
    var audios: [AudioUserParse] = []{
        didSet{
            if tableView != nil && selectBtn != nil{
                tableView.reloadData()
            }
        }
    }
    var currentObj:AudioUserParse?
    var selectedObj:((AudioUserParse)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI Method(s)
    func configureUI(){
        tableView.register(UINib(nibName: "SelectAudioCell", bundle: nil), forCellReuseIdentifier: "SelectAudioCell")
        tableView.delegate = self
        tableView.dataSource = self
        setSelectBtn()
    }
    
    func setSelectBtn(){
        let empty = audios.filter({$0.selected}).isEmpty
        selectBtn.isHidden = empty
    }
    
    //MARK:- Validation Method(s)
    
    
    //MARK:- Service Call Method(s)
    
    
    //MARK:- IBAction Method(s)
    
    @IBAction func selectBtnAction(_ sender: PPFlagSelectButton) {
        self.dismiss(animated: true) {
            if let obj = self.audios.filter({$0.selected}).first{
                self.selectedObj?(obj)
            }
        }
    }
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- TableView Delegate Datasource Method(s)
extension SelectAudioVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectAudioCell", for: indexPath) as! SelectAudioCell
        cell.selectionStyle = .none
        let data = audios[indexPath.row]
        cell.nameLbl.text = data.getPathComponent()
        cell.nameLbl.textColor = data.selected ? PPColor.white : PPColor.identifierBlue
        cell.bgView.backgroundColor = !data.selected ? PPColor.white : PPColor.identifierBlue
        cell.audioFileImgView.image = UIImage(named: data.selected ? "audioFileWhite" : "audioFile")
        cell.playBtn.setImage(UIImage(named: data.selected ? "audioPlayWhite" : "audioPlay"), for: .normal)
        cell.indicatorView.isHidden = true
        cell.playBtn.addTarget(self, action: #selector(playAudio(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func playAudio(sender: UIButton){
        if let cell = sender.superview?.superview?.superview as? SelectAudioCell, let iPath = tableView.indexPath(for: cell), let url = URL(string: audios[iPath.row].data.audioFile){
            let imgView = UIImageView(image: UIImage(named: "appLogo"))
            imgView.alpha = 0
            let player = AVPlayerViewController()
            
            player.contentOverlayView?.addSubview(imgView)
            player.player = AVPlayer(url: url)
            self.present(player, animated: true) {
                if let contentOverlay = player.contentOverlayView{
                    imgView.center = contentOverlay.center
                    UIView.animate(withDuration: 0.2) {
                        imgView.alpha = 1
                    }
                }
                player.player?.play()
            }
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.audios = self.audios.map({ flagObj in
            var mutObj = flagObj
            mutObj.selected = false
            return mutObj
        })
        self.audios[indexPath.row].selected = true
        setSelectBtn()
    }
    
}

