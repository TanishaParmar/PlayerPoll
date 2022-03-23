//
//  ChatDetailsVC.swift
//  PlayerPoll
//
//  Created by Dharmani Apps on 16/11/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Alamofire
import IQKeyboardManagerSwift
class ChatDetailsVC: ChatViewController,InputBarAccessoryViewDelegate {
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var lblName: PPChatNameLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    var fromRoot = false
    var roomId:String? = nil
    var otherUser = ""
    var page = 1
    var isLastPage = false
    var messagesData: [MessagesListing] = []
    var dismissedChat:(()->Void)?
    var profileImage = ""
    var name = ""
    var fromSuperAdmin = false
    var fromAppDel = false
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func textCellSizeCalculator(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CellSizeCalculator? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = name
        if fromSuperAdmin{
            imgProfile.image = UIImage(named: "support")
        }else{
            imgProfile.setImageWithPlaceHolder(with: profileImage)
        }
        messagesCollectionView.shouldResignOnTouchOutsideMode = .enabled
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageOutgoingAvatarSize(.zero)
        messagesCollectionView.messagesCollectionViewFlowLayout.setMessageIncomingAvatarSize(.zero)
        self.navView.bringSubviewToFront(messagesCollectionView)
        self.messagesCollectionView.clipsToBounds = true
//        self.configureMessageInputBar()
        configureData()
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureMessageInputBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismissedChat?()
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.placeholder = "Type a message here...."
        messageInputBar.inputTextView.backgroundColor = PPColor.identifierBlue.withAlphaComponent(0.1)
        messageInputBar.inputTextView.tintColor = PPColor.identifierBlue.withAlphaComponent(0.3)
        messageInputBar.sendButton.setTitleColor(PPColor.identifierBlue, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.red.withAlphaComponent(0.3),
            for: .highlighted
        )
    }

    
    func configureData(){
        guard otherUser != Globals.userId else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        SocketManger.shared.connect()
        generateRoomId { [weak self] roomId in
            self?.roomId = roomId
            self?.onConnectSocket(roomId: roomId)
            self?.getChatMessages(roomId: roomId)
            self?.readAllMessages(roomId: roomId)
        }
    }
    
    func onConnectSocket(roomId: String){
        SocketManger.shared.onConnect {
            SocketManger.shared.socket.emit("ConncetedChat", roomId)
            self.newMessageSocketOn()
        }
    }
    
    func newMessageSocketOn() {
        SocketManger.shared.handleNewMessage { (msgObj) in
            print(msgObj)
            let userId = msgObj["userID"] as? String ?? ""
            let userName = msgObj["userName"] as? String ?? ""
            let created = msgObj["created"] as? String ?? ""
            let date = Date(timeIntervalSince1970: TimeInterval(created.toIntVal()))
            let msg = MockMessage(text: msgObj["message"] as? String ?? "", user: .init(senderId: userId, displayName: userName), messageId: msgObj["id"] as? String ?? "", date: date, read: msgObj["readStatus"] as? String ?? "" == "1")
            self.insertMessage(msg)
            if let rid = self.roomId {
                self.readAllMessages(roomId: rid)
            }
        }
    }
    
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.text ?? ""
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            self.sendChatMessage(message: components) { [weak self] obj in
                if let message = obj, let rid = self?.roomId{
                    let msg = MockMessage(text: message.message, user: .init(senderId: message.userID, displayName: message.userName), messageId: message.id, date: DateFormatterManager.shared.getDate(from: message.created), read: message.readStatus == "1")
                    self?.insertMessage(msg)
                    let chatObj = ["id":message.id,"userID":message.userID,"roomID":message.roomID,"message":message.message,"readStatus":message.readStatus,"created":message.created,"userName":message.userName,"profileImage":message.profileImage]
                    SocketManger.shared.socket.emit("newMessage", rid, chatObj)
                }
                DispatchQueue.main.async { [weak self] in
                    inputBar.sendButton.stopAnimating()
                    inputBar.inputTextView.placeholder = "Type a message here...."
                    inputBar.inputTextView.resignFirstResponder()
                    self?.messagesCollectionView.scrollToLastItem(animated: true)
                }
            }
        }
    }
    
    @objc override func loadMoreMessages(){
        guard !isLastPage else {
            refreshControl.endRefreshing()
            return
        }
        if let rId = roomId {
            self.getChatMessages(roomId: rId)
        }
    }
    
    //MARK:- IBAction Method(s)
    @IBAction func btnCancel(_ sender: Any) {
        if let roomId = self.roomId{
            SocketManger.shared.socket.emit("leaveChat",roomId)
        }
        if fromAppDel{
            appDelegate().setHomeScreen()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    

}


// MARK: - MessagesDisplayDelegate

extension ChatDetailsVC: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return PPColor.white
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let bgColor = isFromCurrentSender(message: message) ? PPColor.identifierBlue : PPColor.darkGray
        return bgColor
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .pointedEdge)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
       
    }
    
    

    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if case MessageKind.photo(let media) = message.kind, let imageURL = media.url?.absoluteString {
            imageView.setImage(with: imageURL)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    // MARK: - Location Messages

    // MARK: - Audio Messages

    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
//        audioController.configureAudioCell(cell, message: message) // this is needed especially when the cell is reconfigure while is playing sound
    }

}

// MARK: - MessagesLayoutDelegate

extension ChatDetailsVC: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 5
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
}


//MARK:- Service Call Method(s)
extension ChatDetailsVC{
    func generateRoomId(completion: @escaping((String)->Void)){
        let url = getFinalUrl(with: .generateRoom)
        let params = ["authToken":Globals.authToken,"otherUserID":otherUser] as [String:AnyObject]
        HUD.showHud()
        print(params)
        DataManager.requestPOSTWithFormData(type: GenerateResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: [[String:Any]]()) { response, status in
            HUD.hideHud()
            if let roomId = response.data?.roomID{
                completion(roomId)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        } failure: { error in
            HUD.hideHud()
            self.navigationController?.popViewController(animated: true)
            print(error.message)
        }
    }
    
    func sendChatMessage(message: String, completion: @escaping((MessagesListing?)->Void)){
        let url = getFinalUrl(with: .sendMessage)
        let params = ["authToken":Globals.authToken,"message":message,"roomID":roomId] as [String:AnyObject]
        print(params)
        DataManager.requestPOSTWithFormData(type: SendMessageResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: []) { response, status in
            completion(response.data)
        } failure: { error in
            completion(nil)
            print(error.message)
        }
    }
    
    func getChatMessages(fromFirst: Bool = false, roomId: String){
        let url = getFinalUrl(with: .getChatMessages)
        let params = ["authToken":Globals.authToken,"perPage":30,"roomID":roomId,"pageNo":self.page] as [String:AnyObject]
        print(params)
        HUD.showHud()
        DataManager.requestPOSTWithFormData(type: MessagesListingResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: []) { [weak self] response, status in
            guard let strongSelf = self else {return}
            HUD.hideHud()
            for data in response.data ?? []{
                let empty = strongSelf.messageList.filter({$0.messageId == data.id}).isEmpty
                if empty{
                    strongSelf.messageList.append(MockMessage(text: data.message, user: .init(senderId: data.userID, displayName: data.userName), messageId: data.id, date: DateFormatterManager.shared.getDate(from: data.created), read: data.readStatus == "1"))
                }
            }
            strongSelf.isLastPage = response.lastPage ?? true
            if !strongSelf.isLastPage{
                strongSelf.page += 1
            }
            DispatchQueue.main.async { [weak self] in
                if strongSelf.page != 1{
                    strongSelf.refreshControl.endRefreshing()
                }
                self?.reloadCollection()
            }
        } failure: { error in
            HUD.hideHud()
            print(error.message)
        }
    }

    func readAllMessages(roomId: String){
        let url = getFinalUrl(with: .updateMessageSeen)
        let params = ["authToken":Globals.authToken,"roomID":roomId] as [String:AnyObject]
        print(params)
        DataManager.requestPOSTWithFormData(type: SendMessageResponseModal.self, strURL: url, params: params, headers: HTTPHeaders([]), imageData: []) { response, status in
            print(response.data)
        } failure: { error in
            print(error.message)
        }
    }
    
    func reloadCollection(){
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem()
    }

}
