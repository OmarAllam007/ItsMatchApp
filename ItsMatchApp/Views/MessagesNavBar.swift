//
//  MessagesNavBar.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 27/08/2022.
//

import Foundation
import UIKit
import LBTATools

class MessagesNavBar:UIView {
    let userImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "profile_image2"))
    let usernameLabel = UILabel(text: "User", font: .systemFont(ofSize: 16))
    let backButton = UIButton(image: UIImage(systemName: "chevron.backward")!,tintColor: #colorLiteral(red: 1, green: 0.3387398124, blue: 0.2800409198, alpha: 1))
    let flagButton = UIButton(image: UIImage(systemName: "flag.fill")!,tintColor: #colorLiteral(red: 1, green: 0.3387398124, blue: 0.2800409198, alpha: 1))
    
    fileprivate let match:MatchModel
    
    init(match:MatchModel){
        self.match = match
        backButton.titleLabel?.font = .systemFont(ofSize: 18)
        flagButton.titleLabel?.font = .systemFont(ofSize: 18)
        
        usernameLabel.text = match.name
        userImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        self.setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        
        let middleStack = hstack(
               stack(
                userImageView,
                     usernameLabel,
                     alignment: .center),
               spacing: 8,
               alignment: .center
            
        )
        
        hstack(backButton,
               middleStack,
               flagButton
        ).withMargins(.init(top: 0, left: 12, bottom: 0, right: 12))
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
