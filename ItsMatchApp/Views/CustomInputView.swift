//
//  CustomInputView.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 29/08/2022.
//

import Foundation
import LBTATools

class CustomInputView:UIView {
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    let placeHolderLabel = UILabel(text:"Enter Message",
                                   font: .systemFont(ofSize: 16),textColor: .lightGray)
    let sendButton  = UIButton(title: "SEND", titleColor: .black,font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    
    let tv = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        
        
        tv.text = ""
        tv.isScrollEnabled = false
        tv.font = .systemFont(ofSize: 16)
        
        sendButton.constrainHeight(50)
        sendButton.constrainWidth(50)
        
        hstack(tv,sendButton.withSize(.init(width: 50, height: 50)),alignment: .center)
            .withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))

        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor,
                                bottom: nil, trailing: sendButton.leadingAnchor,
                                padding: .init(top: 0, left: 18, bottom: 0, right: 16)
        )
        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleTextChange(){
        placeHolderLabel.isHidden = tv.text.count != 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
