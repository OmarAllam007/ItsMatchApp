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
    let buttonsStackView = HomeControllerBottomStackView()
    let cardsView = UIView()
    

    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsStackView.reloadButton.addTarget(self, action: #selector(handleReload), for: .touchUpInside)
        
        setupLayout()
        setupUserCards()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        fetchUsersFromDB()
        
    }
    
    
     @objc fileprivate func handleReload(){
        fetchUsersFromDB()
    }
    
    var lastUserFetchedFromDB:User?
    
    fileprivate func fetchUsersFromDB(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users")
            .order(by: "uid")
            .start(after: [lastUserFetchedFromDB?.uid ?? ""])
            .limit(to: 2)
        
        query.getDocuments { snapshot, error in
            hud.dismiss(animated: true)
            
            if let err = error {
                print(err)
                return
            }
            
            snapshot?.documents.forEach({ docSnapshot in
                let userDictionary = docSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastUserFetchedFromDB = user
                self.setupUserCard(user: user)
            })
            
        }
    }
    
    func setupUserCard(user:User){
        let card = CardView(frame: .zero)
        card.cardViewModel = user.toCardViewModel()
        
        cardsView.addSubview(card)
        cardsView.sendSubviewToBack(card)
    
        card.fillSuperview()
    }
    
    @objc func handleSettings(){
        let registerationController = RegisterationController()
        registerationController.modalPresentationStyle = .fullScreen
        present(registerationController, animated: true)
        
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
    
    
    // MARK: Layout
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let stackViewContainer = UIStackView(arrangedSubviews: [
            topStackView,cardsView,buttonsStackView
        ])
        
        
        stackViewContainer.axis = .vertical
        view.addSubview(stackViewContainer)
        
        stackViewContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        stackViewContainer.isLayoutMarginsRelativeArrangement = true
        stackViewContainer.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        stackViewContainer.bringSubviewToFront(cardsView)
        
    }
    
    
}

