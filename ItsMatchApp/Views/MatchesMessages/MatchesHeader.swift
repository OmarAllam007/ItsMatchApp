//
//  MatchesHeader.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/08/2022.
//

import UIKit
import LBTATools
import Firebase

class MatchesHeader:UICollectionReusableView {
    let newMatchLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 1, green: 0.3387398124, blue: 0.2800409198, alpha: 1))
    let messageshLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 1, green: 0.3387398124, blue: 0.2800409198, alpha: 1))
    let hViewController = MatchesHController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        stack(stack(newMatchLabel).padLeft(20),
              hViewController.view,
              stack(messageshLabel).padLeft(20),
              spacing: 20)
        .withMargins(.init(top: 20, left: 0, bottom: 8, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

