//
//  CardView.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/07/2022.
//

import UIKit
import SDWebImage


protocol CardViewDelegate{
    func didTapMoreInfo(cardViewModel:CardViewModel)
    func didDismissCard(cardView:CardView)
}

class CardView: UIView {
    
    var nextCardView:CardView?
    
    var delegate:CardViewDelegate?
    
//    fileprivate let imageView = UIImageView(image: UIImage(named: "profile_image"))
    
    fileprivate let informationLabel = UILabel()
    
    let gradientLayer = CAGradientLayer()
    fileprivate let threshold:CGFloat = 100
    
    var imageIndex = 0
    fileprivate let barsStackView = UIStackView()
    
    fileprivate let deselectedColor:UIColor = .white.withAlphaComponent(0.1)
    
    
    fileprivate let userPhotosController = UserSwipingPhotosController(isCardViewMode: true)
    
    var cardViewModel:CardViewModel! {
        didSet {
            
            userPhotosController.cardViewModel = self.cardViewModel
            
            informationLabel.attributedText = cardViewModel.attributedText
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.userImageUrls.count).forEach { _ in
                let barView = UIView()
                
                barView.backgroundColor = deselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageObserver()
        }
    }
    
    fileprivate func setupImageObserver(){
        cardViewModel.indexObserver = { [weak self] index,image in
            
            self?.barsStackView.arrangedSubviews.forEach { v in
                v.backgroundColor = self?.deselectedColor
            }
            
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
            
        }
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMove))
        
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    
    
    fileprivate let moreInfoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info.circle.fill")?.withRenderingMode(.alwaysOriginal)
            .withTintColor(.white), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    
   
    
    fileprivate func initUI() {
        clipsToBounds = true
        layer.cornerRadius = 10
        
        let photosView = userPhotosController.view!
        

        addSubview(photosView)
        
        photosView.fillSuperview()
        
        setupGradientLayer()
        
        addSubview(informationLabel)
        
        
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        informationLabel.textColor = .white
        informationLabel.font = .systemFont(ofSize: 34,weight: .heavy)
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 16, right: 16),size: .init(width: 44, height: 44))
        
    }
    
    
    
    
    fileprivate func setupTopBars(){
        addSubview(barsStackView)
        
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: CGSize(width: 0, height: 5))

        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    }
    
    fileprivate func setupGradientLayer(){
        
        gradientLayer.colors = [UIColor.clear.cgColor , UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
        
    }
    
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    

    fileprivate func handleChangingState(_ gesture: UIPanGestureRecognizer) {
        // rotate

        let translation = gesture.translation(in: nil)
        
        let degrees:CGFloat = translation.x / 40
        let angle = degrees * .pi / 180
        let rotation = CGAffineTransform(rotationAngle: angle)
        
        self.transform = rotation.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    fileprivate func handleEndedAnimation(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection:CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismiss = abs(gesture.translation(in: nil).x) > threshold
        
        if shouldDismiss {
            guard let homeController = self.delegate as? HomeController else { return }
            
            if translationDirection == 1 {
                homeController.handleLike()
            }else{
                homeController.handledisLike()
            }
            
        }else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2,options: .curveEaseOut) {
                self.transform = .identity
            }
        }
        
       
        
        
//
//
//        UIView.animate(withDuration: 0.75, delay: 0,
//                       usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1,options: .curveEaseOut) {
//            if shouldDismiss {
//                self.transform = CGAffineTransform(translationX: (self.frame.width + 100) * translationDirection, y: 0)
//            }else{
//                self.transform = .identity
//            }
//
//
//        }completion: { _ in
//            self.transform = .identity
//            if(shouldDismiss){
//                self.removeFromSuperview()
//                self.delegate?.didDismissCard(cardView: self)
//            }
//
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: OBJC =====
    
    @objc fileprivate func handleMoreInfo(){
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    
    @objc fileprivate func handleMove(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            // very important where there alot of animtations in the sametime
            superview?.subviews.forEach({ view in
                view.layer.removeAllAnimations()
            })
        case .changed:
            handleChangingState(gesture)
        case .ended:
            handleEndedAnimation(gesture)
        default:
            ()
        }
    }
    
    
    @objc fileprivate func handleTap(gesture:UITapGestureRecognizer){
        
        //make everythin related to view related to view model state
        let location = gesture.location(in: nil)
        
        let shouldShowNext = location.x > frame.width / 2 ? true : false
        
        if shouldShowNext {
            cardViewModel.toNextImage()
        }else{
            cardViewModel.toPreviousImage()
        }
        
    }
}
