//
//  MatchMessageNavBar.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 22/08/2022.
//

import Foundation
import UIKit
import LBTATools

class MatchMessageNavBar:UIView {
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "03_7").withRenderingMode(.alwaysTemplate), tintColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "03_8").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 1, green: 0.3387398124, blue: 0.2800409198, alpha: 1 )
        let messagesLbl = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 1, green: 0.3387398124, blue: 0.2800409198, alpha: 1)
                                  , textAlignment: .center, numberOfLines: 0)
        
        let feedLbl = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray
                                  , textAlignment: .center, numberOfLines: 0)
        
        
        self.setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        self.stack(iconImageView.withHeight(44),
                   self.hstack(messagesLbl,feedLbl,distribution: .fillEqually)).padTop(10)
        
        
        
        addSubview(backButton)
        
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: .init(top: 12, left: 8, bottom: 0, right: 0), size: .init(width: 34, height: 34))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

