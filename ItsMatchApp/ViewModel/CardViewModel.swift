//
//  CardViewModel.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 01/08/2022.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let imageNames:[String]
    let attributedText:NSAttributedString
    let textAlignment:NSTextAlignment
    
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedText = attributedText
        self.textAlignment = textAlignment
    }
    
    
    private var imageIndex = 0 {
        didSet{
            let imageUrl = self.imageNames[imageIndex]
//            let image = UIImage(named:imageName)
            
            indexObserver?(imageIndex,imageUrl)
        }
    }
    
    
    var indexObserver: ((Int,String?)->())?
    
    func toNextImage(){
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func toPreviousImage(){
        imageIndex = max(0, imageIndex - 1)
    }
}
