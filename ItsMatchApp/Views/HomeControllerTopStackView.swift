//
//  HomeControllerTopStackView.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/07/2022.
//

import UIKit

class HomeControllerTopStackView: UIStackView {

    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(named: "03_7"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fireImageView.contentMode = .scaleAspectFit
        settingsButton.setImage(UIImage(named: "03_6")!.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "03_8")!.withRenderingMode(.alwaysOriginal), for: .normal)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        [settingsButton,UIView(),fireImageView,UIView(),messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
