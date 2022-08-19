//
//  AdertisementViewModel.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 01/08/2022.
//

import UIKit

struct Adertisement:ProducesCardViewModel{
    let title:String
    let adPosterName:String
    let posterPhotoName:String
    
    
    func toCardViewModel() -> CardViewModel {
        let attributeString = NSMutableAttributedString(string: self.title,attributes: [.font:UIFont.systemFont(ofSize: 34,weight: .heavy)])
        
        attributeString.append(NSAttributedString(string: "\n \(self.adPosterName)",attributes: [.font:UIFont.systemFont(ofSize: 20,weight: .regular)]))
        
        return CardViewModel(imageNames: [self.posterPhotoName], attributedText: attributeString, textAlignment: .center,uid: "")
        
    }
}
