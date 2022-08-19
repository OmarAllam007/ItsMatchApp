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
    var imageUrl2:String?
    var imageUrl3:String?
    var uid:String?
    
    var minAge:Int?
    var maxAge:Int?
    
    init(dictionary:[String:Any]){
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1  = dictionary["imageUrl1"] as? String
        self.imageUrl2  = dictionary["imageUrl2"] as? String
        self.imageUrl3  = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
        self.minAge = dictionary["minAge"] as? Int
        self.maxAge = dictionary["maxAge"] as? Int
    }
    
    
    func toCardViewModel() -> CardViewModel {

        let attributeString = NSMutableAttributedString(string: self.name ?? "",attributes: [.font:UIFont.systemFont(ofSize: 32,weight: .heavy)])

        let ageStr = age != nil ? "\(age!)" : "N\\A"
        attributeString.append(NSAttributedString(string: " \(ageStr)",attributes: [.font:UIFont.systemFont(ofSize: 24,weight: .regular)]))


        let professionStr = profession != nil ? "\(profession!)" : "Not Available"
        attributeString.append(NSAttributedString(string: "\n \(professionStr)",attributes: [.font:UIFont.systemFont(ofSize: 20,weight: .regular)]))

        var imageUrls = [String]()
        
        if let imageUrl1 = imageUrl1 {
            imageUrls.append(imageUrl1)
        }
        if let imageUrl2 = imageUrl2 {
            imageUrls.append(imageUrl2)
        }
        if let imageUrl3 = imageUrl3 {
            imageUrls.append(imageUrl3)
        }
        
        return CardViewModel(imageNames: imageUrls, attributedText: attributeString, textAlignment: .left,uid: self.uid!)
    }
}


