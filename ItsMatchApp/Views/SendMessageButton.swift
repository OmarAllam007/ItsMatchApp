//
//  SendMessageButton.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 21/08/2022.
//

import UIKit

class SendMessageButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let grdLayer = CAGradientLayer()
        let rightColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let leftColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        grdLayer.colors = [leftColor.cgColor,rightColor.cgColor]
        grdLayer.startPoint = CGPoint(x: 0, y: 0.5)
        grdLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(grdLayer, at: 0)
        self.layer.cornerRadius = rect.height / 2
        self.clipsToBounds = true
        grdLayer.frame = rect
    }

}
