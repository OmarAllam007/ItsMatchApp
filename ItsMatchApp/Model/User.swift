//
//  User.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 01/08/2022.
//

import UIKit


struct User : ProducesCardViewModel {
    var name:String?
    var age:Int?
    
    var profession:String?
    var imageUrl1:String?
    
    var uid:String?
    
    init(dictionary:[String:Any]){
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1  = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    
    func toCardViewModel() -> CardViewModel {

        let attributeString = NSMutableAttributedString(string: self.name ?? "",attributes: [.font:UIFont.systemFont(ofSize: 32,weight: .heavy)])

        let ageStr = age != nil ? "\(age!)" : "N\\A"
        attributeString.append(NSAttributedString(string: " \(ageStr)",attributes: [.font:UIFont.systemFont(ofSize: 24,weight: .regular)]))


        let professionStr = profession != nil ? "\(profession!)" : "Not Available"
        attributeString.append(NSAttributedString(string: "\n \(professionStr)",attributes: [.font:UIFont.systemFont(ofSize: 20,weight: .regular)]))


        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedText: attributeString, textAlignment: .left)
    }
}


