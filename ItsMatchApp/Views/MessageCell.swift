//
//  MessageCell.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 29/08/2022.
//

import Foundation
import LBTATools

class MessageCell:LBTAListCell<Message> {
    let textView:UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleMessageContainer = UIView(backgroundColor: .lightGray)
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isAuthUserMessage {
                anchorConstraines.trailing?.isActive = true
                anchorConstraines.leading?.isActive = false
                bubbleMessageContainer.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                textView.textColor = .white
            }else {
                anchorConstraines.trailing?.isActive = false
                anchorConstraines.leading?.isActive = true
                bubbleMessageContainer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    
    var anchorConstraines:AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleMessageContainer)
        
        bubbleMessageContainer.layer.cornerRadius = 12
        
        anchorConstraines = bubbleMessageContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchorConstraines.leading?.constant = 20
        anchorConstraines.trailing?.isActive = false
        anchorConstraines.trailing?.constant = -20
        
        
        bubbleMessageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleMessageContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
