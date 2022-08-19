//
//  AgeRangeCell.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 12/08/2022.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    let minSlider:UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        return slider
    }()
    
    let maxSlider:UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 60
        return slider
    }()
    
    let minLabel:UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min: 0"
        return label
    }()
    
    let maxLabel:UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max: 100"
        return label
    }()
    
    class AgeRangeLabel:UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel,minSlider]),
            UIStackView(arrangedSubviews: [maxLabel,maxSlider]),
        ])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 16
        
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
