//
//  CustomTextField.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 02/08/2022.
//

import UIKit


class CustomTextField:UITextField {
    let padding:CGFloat
    
    init(padding:CGFloat, height:CGFloat = 50.0){
        self.padding = padding
        
        super.init(frame: .zero)
        layer.cornerRadius = 15
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
}
