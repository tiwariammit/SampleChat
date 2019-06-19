//
//  ChatVC.swift
//  TestChatApp
//
//  Created by Creator-$ on 6/19/19.
//  Copyright © 2019 tiwariammit@mail.com. All rights reserved.
//

import UIKit
import SocketIO

class ChatVC: JSQMessagesViewController {

    let manager = SocketManager(socketURL: URL(string: "http://localhost:8900")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    var name: String?
    var resetAck: SocketAckEmitter?
    
    var messages = [JSQMessage]()
    let defaults = UserDefaults.standard
   
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    fileprivate var displayName: String!
    
    var chatMessageID:String?
    var messageReceiverID:String?
    var messageSenderID:String?
    var senderName:String?
//    var boolChatClose:Bool? = false///change
    
    var lastMessageKey:String? = ""
    var startingMessageKey:String? = ""
    var topMostMessageKey:String? = ""
    var isEarlierMessagePresent:Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.socket = manager.defaultSocket
        self.setSocketEvent()
        self.socket.connect()
        
        messageSenderID = "10"
        self.senderId = messageSenderID
        self.senderDisplayName = "Ram"
        self.inputToolbar.contentView.leftBarButtonItem = nil
        //self.showLoadEarlierMessagesHeader = true
        
        print(messageSenderID)
        print(self.senderId)
        print(self.senderDisplayName)
        
//
//        if boolChatClose!{
//            inputToolbar.removeFromSuperview()
////            addBrowseRestaurantButton()
//        }
        
        // Do any additional setup after loading the view.
        
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
    
    }
    
    //MARK:- ViewController LifeCycle
    deinit {
        print("ChatMessageViewController deinit")
        
//        if let chatMessageHandle = chatMessageHandle{
//            chatMessageRef?.removeObserver(withHandle: chatMessageHandle)
//            channelRef.removeObserver(withHandle: chatMessageHandle)
//        }
    }
    

    private func setSocketEvent(){
        
        self.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        self.socket.on("currentAmount") {data, ack in
            
            print(data)
//            guard let cur = data[0] as? Double else { return }
//
//            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                socket.emit("update", ["amount": cur + 2.50])
//            }
            
            ack.with("Got your currentAmount", "dude")
        }
        
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
            print(messages)
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let currentTime:Int = Int(getCurrentMillis())
        print(currentTime)
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        print(senderId)
        print(message.senderId)
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
