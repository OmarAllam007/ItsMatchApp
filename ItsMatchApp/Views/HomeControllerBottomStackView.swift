//
//  HomeControllerBottomStackView.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/07/2022.
//

import UIKit

class HomeControllerBottomStackView: UIStackView {
    
    static func createButton(image:UIImage) -> UIButton {
        let b = UIButton(type: .system)
        b.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        return b
    }
    
    let reloadButton = createButton(image: UIImage(named: "03_1")!)
    let dislikeButton = createButton(image: UIImage(named: "03_2")!)
    let superLikeButton = createButton(image: UIImage(named: "03_3")!)
    let likeButton = createButton(image: UIImage(named: "03_4")!)
    let specialButton = createButton(image: UIImage(named: "03_5")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [reloadButton,dislikeButton,superLikeButton,likeButton,specialButton]
            .forEach { button in
                self.addArrangedSubview(button)
            }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
