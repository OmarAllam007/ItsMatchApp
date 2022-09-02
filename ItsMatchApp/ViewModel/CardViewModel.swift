import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    let userImageUrls:[String]
    let attributedText:NSAttributedString
    let textAlignment:NSTextAlignment
    let uid:String
    
    
    init(imageNames: [String], attributedText: NSAttributedString, textAlignment: NSTextAlignment, uid:String) {
        self.userImageUrls = imageNames
        self.attributedText = attributedText
        self.textAlignment = textAlignment
        self.uid = uid
    }
    
    
    private var imageIndex = 0 {
        didSet{
            let imageUrl = self.userImageUrls[imageIndex]
            indexObserver?(imageIndex,imageUrl)
        }
    }
    
    
    var indexObserver: ((Int,String?)->())?
    
    func toNextImage(){
        imageIndex = min(imageIndex + 1, userImageUrls.count - 1)
    }
    
    func toPreviousImage(){
        imageIndex = max(0, imageIndex - 1)
    }
}
