//
//  MatchCell.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/08/2022.
//
import LBTATools
import UIKit

class MatchCell: LBTAListCell<MatchModel>{
    
    let profileImageView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "profile_image2"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 14,weight: .semibold),textColor: .darkGray,textAlignment: .center,numberOfLines: 2)
    
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        stack(stack(profileImageView,alignment: .center),usernameLabel)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var item: MatchModel! {
        didSet{
            usernameLabel.text = item.name
            
            profileImageView.sd_setImage(with: URL(string:item.profileImageUrl))
        }
    }
}
