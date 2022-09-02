//
//  ChatController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 23/08/2022.
//

import Foundation
import LBTATools
import UIKit
import Firebase



class ChatController:LBTAListController<MessageCell,Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: match)
    
    fileprivate let navBarHeight:CGFloat = 120
    
    fileprivate let match:MatchModel
    
    init(match:MatchModel){
        self.match = match
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var inputCustomView:CustomInputView = {
        let view = CustomInputView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        view.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return view
    }()
    
    
    
    fileprivate func saveFromAndToMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let collection = Firestore.firestore().collection("matches_messages")
            .document(currentUserId).collection(match.uid)
        
        let data:[String:Any] = [
            "text": inputCustomView.tv.text ?? "",
            "fromId":currentUserId,
            "toId":match.uid,
            "timestamp": Timestamp(date: Date()),
            "uid": match.uid
        ]
        
        collection.addDocument(data: data) { error in
            if let error = error {
                print("mgs send error")
                return
            }
        }
        
        
        let toCollection = Firestore.firestore().collection("matches_messages")
            .document(match.uid).collection(currentUserId)
        
        toCollection.addDocument(data: data) { error in
            if let error = error {
                print("mgs send error")
                return
            }
        }
    }
    
    
    
    fileprivate func saveToAndFromRecentMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dictData:[String:Any] = [
            "text": inputCustomView.tv.text ?? "", "name":match.name,
            "profileImageUrl": match.profileImageUrl, "timestamp": Timestamp(date: Date()),
            "uid":match.uid
        ]
        
        Firestore.firestore().collection("matches_messages")
            .document(currentUserId)
            .collection("recent_messages")
            .document(match.uid)
            .setData(dictData) { error in
                if let error = error {
                    print(error)
                    return
                }
                    
                print("saved recent messages")
            }
        
        guard let currentUser = self.currentUser else { return }
        
        let anotherDictData:[String:Any] = [
            "text": inputCustomView.tv.text ?? "", "name": currentUser.name ?? "",
            "profileImageUrl": currentUser.imageUrl1 ?? "", "timestamp": Timestamp(date: Date()),
            "uid": currentUserId
        ]
        
        
        Firestore.firestore().collection("matches_messages")
            .document(match.uid)
            .collection("recent_messages")
            .document(currentUserId)
            .setData(anotherDictData)
        
        
    }
    
    @objc fileprivate func handleSend(){
        saveFromAndToMessages()
        saveToAndFromRecentMessages()
        
        self.inputCustomView.tv.text = nil
        self.inputCustomView.placeHolderLabel.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputCustomView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    fileprivate func fetchMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let query = Firestore.firestore().collection("matches_messages")
            .document(currentUserId)
            .collection(match.uid)
            .order(by: "timestamp")
        
        
        query.addSnapshotListener { snapshot, error in
            if let err = error {
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dict = change.document.data()
                    self.items.append(.init(dictionary: dict))
                    
                }
            })
            
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
    }
    
    fileprivate func setupUI() {
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        
        let statusBarView = UIView(backgroundColor: .white)
        
        view.addSubview(statusBarView)
        statusBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    
    var currentUser:User?
    
    func fetchCurrentUser(){
        Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "")
            .getDocument { snapshot, error in
                let data = snapshot?.data() ?? [:]
                self.currentUser = User(dictionary: data)
            }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        fetchMessages()
        setupUI()
    }
    
    @objc fileprivate func handleKeyboardShow(){
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    @objc fileprivate func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
}
