//
//  MatchesHController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/08/2022.
//

import UIKit
import Firebase
import LBTATools



class MatchesHController:LBTAListController<MatchCell,MatchModel>, UICollectionViewDelegateFlowLayout {
    
    var rootController:MatchesMessagesController?
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = self.items[indexPath.item]
        rootController?.didSelectMatchFromHeader(match: match)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        
        fetchMatches()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: view.frame.height)
    }
    
    
    fileprivate func fetchMatches(){
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("matches_messages")
            .document(currentUserId)
            .collection("matches")
            .getDocuments { snapshot, err in
                if let err = err {
                    print(err)
                    return
                }
                
                var matches = [MatchModel]()
                
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    matches.append(.init(dict: dict))
                })
                
                self.items = matches
                self.collectionView.reloadData()
            }
    }
    
}
