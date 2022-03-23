//
//  ChatViewController.swift
//  PlayerPoll
//
//  Created by mac on 04/12/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

/// A base class for the example controllers
class ChatViewController: MessagesViewController, MessagesDataSource {

    // MARK: - Public properties

    /// The `BasicAudioController` control the AVAudioPlayer state (play, pause, stop) and update audio cell UI accordingly.

    lazy var messageList: [MockMessage] = []
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()

    // MARK: - Private properties

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy hh:mm a"
        return formatter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectionView()
       // configureMessageInputBar()
        title = "MessageKit"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
//            SampleData.shared.getMessages(count: 20) { messages in
//                DispatchQueue.main.async {
//                    self.messageList.insert(contentsOf: messages, at: 0)
//                    self.messagesCollectionView.reloadDataAndKeepOffset()
//                    self.refreshControl.endRefreshing()
//                }
//            }
        }
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.showsVerticalScrollIndicator = false
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        showMessageTimestampOnSwipeLeft = true // default false
        messagesCollectionView.refreshControl = refreshControl
    }
    
//    func configureMessageInputBar() {
//        messageInputBar.delegate = self
//        messageInputBar.inputTextView.tintColor = .lightGray
//        messageInputBar.sendButton.setTitleColor(.red, for: .normal)
//        messageInputBar.sendButton.setTitleColor(
//            UIColor.red.withAlphaComponent(0.3),
//            for: .highlighted
//        )
//    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    // MARK: - MessagesDataSource

    func currentSender() -> SenderType {
        return MessageModal.currentUser
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        var tickVal = ""
        if indexPath.row == messageList.count - 1{
            if messageList[indexPath.row].sender.senderId == currentSender().senderId{
                tickVal = messageList[indexPath.row].read ? "✓✓" : ""
            }
        }
        return NSAttributedString(string: tickVal, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }

//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//    }
//
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = DateFormatterManager.shared.checkAndReturnDate(date: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }

    
//
    func textCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        return nil
    }

}

extension Date {
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
}
// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
       
    }

    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }

}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }

    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }

    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }

    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
}

// MARK: - MessageInputBarDelegate

extension ChatViewController  {

   

//    func processInputBar(_ inputBar: InputBarAccessoryView) {
//        // Here we can parse for which substrings were autocompleted
//        let attributedText = inputBar.inputTextView.attributedText!
//        let range = NSRange(location: 0, length: attributedText.length)
//        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
//
//            let substring = attributedText.attributedSubstring(from: range)
//            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
//            print("Autocompleted: `", substring, "` with context: ", context ?? [])
//        }
//
//        let components = inputBar.inputTextView.components
//        inputBar.inputTextView.text = String()
//        inputBar.invalidatePlugins()
//        // Send button activity animation
//        inputBar.sendButton.startAnimating()
//        inputBar.inputTextView.placeholder = "Sending..."
//        // Resign first responder for iPad split view
//        inputBar.inputTextView.resignFirstResponder()
//        DispatchQueue.global(qos: .default).async {
//            // fake send request task
//            sleep(1)
//            DispatchQueue.main.async { [weak self] in
//                inputBar.sendButton.stopAnimating()
//                inputBar.inputTextView.placeholder = "Aa"
//                self?.insertMessages(components)
//                self?.messagesCollectionView.scrollToLastItem(animated: true)
//            }
//        }
//    }

    private func insertMessages(_ data: [Any]) {
//        for component in data {
//            let user = SampleData.shared.currentSender
//            if let str = component as? String {
//                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
//                insertMessage(message)
//            } else if let img = component as? UIImage {
//                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
//                insertMessage(message)
//            }
//        }
    }
}
