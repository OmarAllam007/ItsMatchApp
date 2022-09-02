//
//  MatchesMessagesController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 22/08/2022.
//

import UIKit
import LBTATools
import Firebase

struct RecentMessage{
    let text, uid, name,profileImageUrl:String
    let timestamp:Timestamp
    
    init(dict:[String:Any]){
        self.text = dict["text"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.profileImageUrl = dict["profileImageUrl"] as? String ?? ""
        self.timestamp = dict["timestampe"] as? Timestamp ?? Timestamp(date: Date())
        
    }
}

class RecentMessageCell:LBTAListCell<RecentMessage> {
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "profile_image2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 18))
    let messageTextLbl = UILabel(text: "Here is a new latest message", font: .systemFont(ofSize: 16),textColor: .gray,numberOfLines: 2)
    
    
    override var item: RecentMessage! {
        didSet {
            usernameLabel.text = item.name
            messageTextLbl.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    
    override func setupViews() {
        super.setupViews()
        userProfileImageView.layer.cornerRadius = 94 / 2
        
        
        hstack(userProfileImageView.withWidth(94).withHeight(94),
               stack(usernameLabel,messageTextLbl,spacing: 2),
               spacing: 20,
               alignment: .center
        )
        .padLeft(20)
        .padRight(20)
        
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
    }
}



class MatchesMessagesController: LBTAListHeaderController<RecentMessageCell,RecentMessage,MatchesHeader> {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func setupHeader(_ header: MatchesHeader) {
        header.hViewController.rootController = self
    }
    
    func didSelectMatchFromHeader(match:MatchModel){
        let controller = ChatController(match: match)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }

    
    let usersCell = "userCell"
    let customNavBar = MatchMessageNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUI()
        
        fetchRecentMessages()
        
        
        
        let statusBarView = UIView(backgroundColor: .white)
        
        view.addSubview(statusBarView)
        statusBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        collectionView.verticalScrollIndicatorInsets.top = 150
    }
    
    fileprivate func fillUI() {
        collectionView.backgroundColor = .white
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,size: .init(width: 0, height: 100))
        
        collectionView.contentInset.top = 130
        
        
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: "userCell")
    }
    
    @objc fileprivate func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    
    var recentMessagesDict = [String:RecentMessage]()
    func fetchRecentMessages(){
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        Firestore.firestore().collection("matches_messages")
            .document(currentUserId)
            .collection("recent_messages")
            .addSnapshotListener { querySnapshot, error in
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added || change.type == .modified {
                        let dict = change.document.data()
                        let recentMessage = RecentMessage(dict: dict)
                        self.recentMessagesDict[recentMessage.uid] = recentMessage
                    }
                })
                
                self.resetItems()
            }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = self.items[indexPath.item]
        
//
        let dict = ["name": message.name,
                    "profileImageUrl":message.profileImageUrl,"uid":message.uid]
        
        
//
        let match = MatchModel(dict: dict)
        
        let chatLogController = ChatController(match: match)
        self.navigationController?.pushViewController(chatLogController, animated: true)
        
    }
    func resetItems(){
        let values = Array(recentMessagesDict.values).sorted { rm1, rm2 in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        }
        
        items = values
        collectionView.reloadData()
    }
}




extension MatchesMessagesController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
