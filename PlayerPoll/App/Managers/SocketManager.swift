//
//  SocketManager.swift
//  PlayerPoll
//
//  Created by mac on 09/12/21.
//

import Foundation
import SocketIO

class SocketManger {
    
//    static let shared = SocketManger()
    
    let manager = SocketManager(socketURL: URL(string: "https://jaohar-uk.herokuapp.com")!, config: [.log(true), .compress])
    
    var socket: SocketIOClient!
    
    init() {
        socket = manager.defaultSocket
    }
        
    deinit {
        print("SocketManger deinit calls")
    }
    
    
    func connect() {
        guard socket != nil else { return }
        socket.connect()
    }
    func disconnect() {
        socket.disconnect()
        socket = nil
    }
    
    func checkConnectionStatus() {
        guard socket != nil else { return }
        let status = socket.status
        print("socket status is \(status)")
    }
    
    
    func onConnect(handler: @escaping () -> Void) {
        guard socket != nil else { return }
        socket.on("connect") { (_, _) in
            handler()
        }
    }
    func handleNewMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        guard socket != nil else { return }
        socket.on("newMessage") { (data, ack) in
            handler(data[1] as! [String:Any])
        }
    }
    func handleJoinedMessage(handler: @escaping (_ message: [String: Any]) -> Void) {
        guard socket != nil else { return }
        socket.on("ChatStatus") { (data, ack) in
            print(data[1])
            let msg = data[1] as! [String: Any]
            handler(msg)
        }
    }
    func handleUserTyping(handler: @escaping (_ trueIndex: Int) -> Void) {
        guard socket != nil else { return }
        socket.on("type") { (data, ack) in
            let trueIndex = data[1] as? Int
            handler(trueIndex!)
        }
    }
    func handleUserStopTyping(handler: @escaping () -> Void) {
        guard socket != nil else { return }
        socket.on("userStopTyping") { (_, _) in
            handler()
        }
    }
}
