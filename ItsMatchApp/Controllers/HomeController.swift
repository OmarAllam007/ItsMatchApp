//
//  ViewController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/07/2022.
//

import UIKit
import Firebase
import JGProgressHUD




class HomeController: UIViewController {
    let topStackView = HomeControllerTopStackView()
    let bottomStackView = HomeControllerBottomStackView()
    let cardsView = UIView()
    

    var cardViewModels = [CardViewModel]()
    var lastUserFetchedFromDB:User?
    
    
    fileprivate var user:User?
    
    fileprivate let hud = JGProgressHUD(style: .dark)
    var topCardView:CardView?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        
        bottomStackView.reloadButton.addTarget(self, action: #selector(handleReload), for: .touchUpInside)
        
        setupLayout()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        bottomStackView.dislikeButton.addTarget(self, action: #selector(handledisLike), for: .touchUpInside)
        
        fetchCurrentUser()
        
    }
    
    
    func setupUserCard(user:User) -> CardView {
        let card = CardView(frame: .zero)
        card.delegate = self
        card.cardViewModel = user.toCardViewModel()
        
        cardsView.addSubview(card)
        cardsView.sendSubviewToBack(card)
    
        card.fillSuperview()
        
        return card
    }
    
    
    // MARK: private functions
    fileprivate func setupUserCards(){
        cardViewModels.forEach { vm in
            
            let card = CardView(frame: .zero)
            card.cardViewModel = vm
            
            cardsView.addSubview(card)
            card.fillSuperview()
        }
        
    }
    
    
    fileprivate func fetchCurrentUser(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        
        cardsView.subviews.forEach({$0.removeFromSuperview()})
        
        Firestore.firestore().collection("users").document(userId).getDocument { snapshot, error in
            if let err = error {
                print(err)
                self.hud.dismiss(animated: true)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return }
            self.user = User(dictionary: dictionary)
            
//            self.fetchUsersFromDB()
            
            self.fetchUsersNotSwipes()
            self.hud.dismiss(animated: true)
        }
    }

    var swipes = [String:Int]()
    fileprivate func fetchUsersNotSwipes(){
        
        guard let uid = Auth.auth().currentUser?.uid else {  return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            guard let data = snapshot?.data() as? [String:Int]else {  return }
            self.swipes = data
            self.fetchUsersFromDB()
        }
    }
    
    fileprivate func fetchUsersFromDB(){
        let minAge = user?.minAge ?? SettingsController.defaultMinAge
        let maxAge = user?.maxAge ?? SettingsController.defaultMaxAge
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users")
            .order(by: "age")
            .whereField("age", isGreaterThanOrEqualTo:minAge)
            .whereField("age", isLessThanOrEqualTo:maxAge)
            .limit(to: 10)

        query.getDocuments { snapshot, error in
            hud.dismiss(animated: true)
            
            if let err = error {
                print(err)
                return
            }
            
            var prevCard:CardView?
            self.topCardView = nil
            
            snapshot?.documents.forEach({ docSnapshot in
                let userDictionary = docSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.users[user.uid!] = user
                
                let isNotAuthUser = user.uid != Auth.auth().currentUser?.uid
                
                let hasNotSwipedBefore = true
                
                if  isNotAuthUser && hasNotSwipedBefore {
                    let cardView = self.setupUserCard(user: user)
                    
                    prevCard?.nextCardView = cardView
                    prevCard = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                    
                }
//
            })
            
        }
    }
    
    var users = [String:User]()
    
    // MARK: Layout
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let stackViewContainer = UIStackView(arrangedSubviews: [
            topStackView,cardsView,bottomStackView
        ])
        
        
        stackViewContainer.axis = .vertical
        view.addSubview(stackViewContainer)
        
        stackViewContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        stackViewContainer.isLayoutMarginsRelativeArrangement = true
        stackViewContainer.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        stackViewContainer.bringSubviewToFront(cardsView)
        
    }
    
    
    
    fileprivate func saveSwipeToDB(didLike:Int){

        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardId = topCardView?.cardViewModel.uid else { return }
                
        
        let documentData = [
            cardId:didLike
        ]
        
        let ref = Firestore.firestore().collection("swipes").document(uid)
        

        ref.getDocument { snapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            if snapshot?.exists == true {
                ref.updateData(documentData) { error in
                    if let err = error {
                        print(err)
                        return
                    }
                    
                    if didLike == 1 {
                        self.checkMatch(cardId: cardId)
                    }
                }
                
                
            }else{
                ref.setData(documentData) { error in
                    if let err = error {
                        print(err)
                        return
                    }
                    if didLike == 1 {
                        self.checkMatch(cardId: cardId)
                    }
                    
                }
            }
        
        }
        
        
        
       
    }
    
    fileprivate func checkMatch(cardId:String){
        
        Firestore.firestore().collection("swipes").document(cardId).getDocument { snapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            
            if hasMatched {
                
                self.presentMatchView(cardUID: cardId)
                
                
                guard let user = self.users[cardId] else { return }
                
                let matchData:[String:Any] = [
                    "name": user.name ?? "",
                    "profileImageUrl":user.imageUrl1 ?? "",
                    "uid": cardId,
                    "timestamp":Timestamp(date: Date())
                ]
    
                
                Firestore.firestore().collection("matches_messages")
                    .document(uid)
                    .collection("matches")
                    .document(cardId)
                    .setData(matchData) { error in
                        if let err = error{
                            return
                        }
                    }
                
                
                guard let currentUser = self.user else { return }
                let otherUserMatched:[String:Any] = [
                    
                    "name": currentUser.name ?? "",
                    "profileImageUrl":currentUser.imageUrl1 ?? "",
                    "uid": currentUser.uid,
                    "timestamp":Timestamp(date: Date())
                ]
    
                
                Firestore.firestore().collection("matches_messages")
                    .document(cardId)
                    .collection("matches")
                    .document(uid)
                    .setData(otherUserMatched) { error in
                        if let err = error{
                            return
                        }
                    }
            }
        }
        
    }
    
    fileprivate func presentMatchView(cardUID:String){
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
}


// MARK: Extensions =============

extension HomeController:CardViewDelegate {
    func didDismissCard(cardView: CardView) {
        self.topCardView = self.topCardView?.nextCardView
    }
    
    func didTapMoreInfo(cardViewModel:CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
}

extension HomeController:SettingsControllerDelegate {
    func didSaveSettings() {
        self.fetchCurrentUser()
    }
    
}

extension HomeController:LoginControllerDelegate{
    func didFinishLoggingIn() {
        self.fetchCurrentUser()
    }
    
}


// MARK: OBJC ==========
extension HomeController{
    
    
    @objc func handleSettings(){
        let settingsController = SettingsController()
        settingsController.settignsDelegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        
    }
    
     @objc fileprivate func handleReload(){
         cardsView.subviews.forEach({$0.removeFromSuperview()})
         fetchUsersFromDB()
    }
    
    @objc fileprivate func handleMessages(){
        let messagesVC = MatchesMessagesController()
        navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    
    fileprivate func prepareSwipeAnimation(translation:CGFloat,angle:CGFloat){
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        
        translationAnimation.toValue = translation
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 100
        rotationAnimation.duration = 0.5
        
        let cardView = topCardView
        self.topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "transaltion")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    @objc  func handleLike(){
        saveSwipeToDB(didLike:1)
        
        // we use this way as UIView.animate not good with fast clicking
        prepareSwipeAnimation(translation: 700, angle: 15)
        
    }
    
    @objc  func handledisLike(){
        saveSwipeToDB(didLike:0)
        prepareSwipeAnimation(translation: -700, angle: -15)
    }
}
