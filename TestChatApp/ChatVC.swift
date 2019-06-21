//
//  ChatVC.swift
//  TestChatApp
//
//  Created by Creator-$ on 6/19/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit
import Starscream


class ChatVC: JSQMessagesViewController {
    
    //    private let socket = WebSocket(url: URL(string: Urls.socketChatBaseUrl)!)
    //, protocols: ["/user/47/queue/specific-user"]
    
    
    //    var socketClient = StompClientLib()
    
    private let socket = WebSocket(url: URL(string: "https://dearjini.xyz/chat/buyer/websocket")!)
    
    private var messages = [JSQMessage]()
    
    lazy private var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy private var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
//    public var chatHistoryModel : ChatHistoryModel?
    
    public var messageReceiverID:String!
    public var messageSenderID:String!
    
    private var senderName:String? = "Unknown"
    
    var name: String?
    
    let defaults = UserDefaults.standard
    
    fileprivate var displayName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.insertInitialMessage()
    
        socket.delegate = self
        self.establishConnection()
        
        //        socket.disableSSLCertValidation = true
        
        
        //        socket.enableCompression = false
        
        self.navigationItem.title = self.senderName
        
        self.senderId = "1"
        self.senderDisplayName = self.senderName ?? "Unknown"
        self.inputToolbar.contentView.leftBarButtonItem = nil
     
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.showLoadEarlierMessagesHeader = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.collectionView.backgroundColor = .yellow
    }
    
    //MARK:- ViewController LifeCycle
    deinit {
        print("ChatVC deinit")
    }
    
    func establishConnection() {
        self.socket.connect()
        
    }
    
    
    func closeConnection() {
        self.socket.disconnect()
    }
    
    private func insertInitialMessage(){
//        guard let model = self.chatHistoryModel?.history else {
//            return
//        }
//
//        DispatchQueue.backgroundThead(delay: 0, background: {
//            [weak self] in
//            guard let `self` = self else { return }
//            for item in model{
//                if let id = item.id, let message = item.message{
//                    let name = item.from ?? ""
//
//                    self.addMessage(withId: id.description, name: name, text: message, loadEarlierBool: false)
//                }
//            }
//        }) {
//
//            self.finishSendingMessage()
//            self.establishConnection()
//        }
    }
    
    
    private func subscribeToChatRoom(){
        //        let type = "/user/47/queue/specific-user"
        //        socket.write(string: type)
        
        //         let data = ["type":type]
        //        let valid = JSONSerialization.isValidJSONObject(data)
        //        if valid {
        //            do {
        //                let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions()) as NSData
        //                if let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as String? {
        //                    print("json string = \(jsonString)")
        //                }
        //            } catch _ {
        //                print ("JSON Failure")
        //            }
        //        }
        
    }
    
}

extension ChatVC{
    
    // MARK: UI and User Interaction
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    private func addMessage(withId id: String, name: String, text: String, loadEarlierBool: Bool) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            //messages.append(message)
            if loadEarlierBool{
                messages.insert(message, at: 0)
            }else{
                messages.append(message)
            }
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //        let currentTime:Int = Int(getCurrentMillis())
        //        print(currentTime)
        
        
        var jsonObject = [String: String]()
        jsonObject["from"] = "47"
        jsonObject["to"] = "1"
        jsonObject["message"] = text
        
        //        socket.emit("my event", jsonObject)
        
        let type = "/app/chat/buyer"
        let data = [type:jsonObject] as [String : AnyObject]
        let valid = JSONSerialization.isValidJSONObject(data)
        if valid {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions()) as Data
                
                if let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as String? {
                    print("json string = \(jsonString)")
                    
                    socket.write(string: jsonString) {
                        print("completed")
                        
                        self.addMessage(withId: self.senderName!, name: self.senderName!, text: text, loadEarlierBool: false)
                        
                        self.finishSendingMessage()
                        JSQSystemSoundPlayer.jsq_playMessageSentSound()
                        
                    }
                }
            } catch _ {
                print ("JSON Failure")
            }
        }
        
        //        self.finishReceivingMessage()
        
        //        self.send
        //
        //        let messageItemRef = channelRef.child(serverEnvironment).child("chat").child("messages").child("\(chatMessageID!)").childByAutoId()
        //        let unreadRef = channelRef.child(serverEnvironment).child("chat").child("unread").child("\(messageReceiverID!)").childByAutoId().childByAutoId()
        //        let historySenderRef = channelRef.child(serverEnvironment).child("chat").child("history").child("\(messageSenderID!)").child("\(messageReceiverID!)")
        //        let HistoryReceiverRef = channelRef.child(serverEnvironment).child("chat").child("history").child("\(messageReceiverID!)").child("\(messageSenderID!)")
        //
        //        //let itemRef = messageRef.child("\(chatMessageID!)").childByAutoId()
        //        let messageDict = [
        //            "message": text!,
        //            "senderID": senderId!,
        //            "status": 0,
        //            "timeStamp": currentTime] as [String : Any]
        //
        //        let senderDict = [
        //            "lastMessage": text!,
        //            "senderID": senderId!,
        //            "fromServer": false,
        //            "timeStamp": currentTime] as [String : Any]
        //
        //        let receiverDict = [
        //            "lastMessage": text!,
        //            "senderID": senderId!,
        //            "fromServer": false,
        //            "timeStamp": currentTime] as [String : Any]
        //
        //        messageItemRef.setValue(messageDict)
        //        unreadRef.setValue(senderDisplayName!)
        //        historySenderRef.updateChildValues(senderDict)
        //        HistoryReceiverRef.updateChildValues(receiverDict)
        //
        //        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        //
        //        finishSendingMessage() // 5
        //
        //isTyping = false
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        print("load earlier message")
        self.showLoadEarlierMessagesHeader = false
        //        readEarlierMessageFromFireBase(key: self.startingMessageKey!)
        
        
    }
    
    // MARK: UITextViewDelegate methods
    
    // MARK: Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        //        print(senderId)
        //        print(message.senderId)
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
}




extension ChatVC : WebSocketDelegate {
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some text: \(data)")

    }


    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")

        let type = "/user/47/queue/specific-user"
        self.socket.write(string: type) {
            print("Observer Activated")
        }
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }

}



//        self.socket.rx.text.subscribe(onNext: { (message: String) in
//            print("Message : \(message)")
//        }).disposed(by: disposeBag)

//        self.subscribeToChatRoom()

//        self.socket.write(string: type)


//extension ChatVC : StompClientLibDelegate{
//
//    func registerSocket(){
////        let baseURL = "http://localhost:8080/"
////        // Cut the first 7 character which are "http://" Not necessary!!!
////        // substring is depracated in iOS 11, use prefix instead :)
////
////        let wsURL = baseURL.substring(from:baseURL.index(baseURL.startIndex, offsetBy: 7))
////        let completedWSURL = "ws://\(wsURL)hello/websocket"
//
//        let url = URL(string: Urls.socketChatBaseUrl)!
//        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate)
//
//    }
//
//    func stompClientDidConnect(client: StompClientLib!) {
//        let topic = "/user/47/queue/specific-user"
//        print("Socket is Connected : \(topic)")
//        socketClient.subscribe(destination: topic)
//        // Auto Disconnect after 3 sec
////        socketClient.autoDisconnect(time: 5)
//        // Reconnect after 4 sec
//        socketClient.reconnect(request: NSURLRequest(url: URL(string: Urls.socketChatBaseUrl)!) , delegate: self as StompClientLibDelegate, time: 4.0)
//    }
//
//    func stompClientDidDisconnect(client: StompClientLib!) {
//        print("Socket is Disconnected")
//    }
//
//    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, withHeader header: [String : String]?, withDestination destination: String) {
//        print("DESTIONATION : \(destination)")
//        print("JSON BODY : \(String(describing: jsonBody))")
//    }
//
//    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
//        print("DESTIONATION : \(destination)")
//        print("String JSON BODY : \(String(describing: jsonBody))")
//    }
//
//    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
//        print("Receipt : \(receiptId)")
//    }
//
//    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
//        print("Error : \(String(describing: message))")
//    }
//
//    func serverDidSendPing() {
//        print("Server Ping")
//    }
//}

