//
//  MatchView.swift
import UIKit
import Firebase
class MatchView: UIView {
    
    var currentUser:User!{
        didSet{
            
        }
    }
    
    var cardUID:String! {
        didSet{
            let query  = Firestore.firestore().collection("users")
            query.document(cardUID).getDocument { snapshot, err in
                if let error = err {
                    print("MATCHVIEW: ",error)
                    return
                }
                
                guard let userDic = snapshot?.data() else { return }
                let matchedUser = User(dictionary: userDic)
                
                
                guard let matchedUserUrl = URL(string: matchedUser.imageUrl1 ?? "") else { return }
                self.cardUserImageView.alpha = 1
                self.cardUserImageView.sd_setImage(with: matchedUserUrl)
                
                guard let currentUserUrl = URL(string: self.currentUser.imageUrl1 ?? "") else { return }
                
                self.currentUserImageView.sd_setImage(with: currentUserUrl) { _, _, _, _ in
                    self.descriptionLabl.text = "You and \(matchedUser.name ?? "") liked each other"
                    self.setupAnimation()
                }
                
            }
        }
    }
    
    fileprivate let itsMatchImageView:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "match"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabl:UILabel = {
        let label = UILabel()
        label.text = "You matched with"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let currentUserImageView:UIImageView = {
        let iv = UIImageView(image:  #imageLiteral(resourceName: "profile_image2"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    fileprivate let cardUserImageView:UIImageView = {
        let iv = UIImageView(image:  #imageLiteral(resourceName: "profile_image"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.alpha = 0
        return iv
    }()
    
    fileprivate let sendMessageButton:UIButton = {
        let b = SendMessageButton(type: .system)
        b.setTitle("Send Message".uppercased(), for: .normal)
        b.tintColor = .white
        return b
    }()
    
    
    fileprivate let continueButton:ContinueSwipeButton = {
        let b = ContinueSwipeButton(type: .system)
        b.setTitle("Keep Swiping".uppercased(), for: .normal)
        b.tintColor = .white
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        
        setupLayout()
//        setupAnimation()
    }
    
    
    fileprivate func setupAnimation(){
        views.forEach { v in
            v.alpha = 1
        }
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform =
        CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        
        cardUserImageView.transform =
        CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        continueButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3) {
                self.cardUserImageView.transform = .identity
                self.currentUserImageView.transform = .identity
                
            }
            
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.65 * 1.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            self.sendMessageButton.transform = .identity
            self.continueButton.transform = .identity
        } completion: { _ in
            
        }
        
    }
    
    
    lazy var views = [
        itsMatchImageView,
        descriptionLabl,
        currentUserImageView,
        cardUserImageView,
        sendMessageButton,
        continueButton
    ]
    fileprivate func setupLayout(){
        views.forEach { v in
            addSubview(v)
            v.alpha = 0
        }
        
        itsMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabl.topAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 16, right: 0),size: .init(width: 300, height: 80))
        
        itsMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        descriptionLabl.anchor(top: nil, leading: self.leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: self.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 30, right: 0),size: .init(width: 0, height: 50))
        
        
        let imageWidth:CGFloat = 140
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor,padding: .init(top: 0, left: 0, bottom: 0, right:16 ),size: .init(width: imageWidth, height: imageWidth))
        
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentUserImageView.layer.cornerRadius = 140 / 2
        
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil,padding: .zero,size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = 140 / 2
        
        
        
        
        self.createBottomButtons()
        
    }
    
    fileprivate func createBottomButtons(){
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor,padding: .init(top: 32, left: 48, bottom: 0, right: 48),size: .init(width: 0, height: 50))
        
        continueButton.anchor(top: sendMessageButton.bottomAnchor, leading: sendMessageButton.leadingAnchor, bottom: nil, trailing: sendMessageButton.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 50))
        
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupBlurView(){
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.visualEffectView.alpha = 1
        }
    }
    
    @objc fileprivate func handleTapDismiss(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
