//
//  UserDetailsViewController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 15/08/2022.
//

import UIKit


extension UserDetailsController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Some Math to animate the top image
        
        let yDegree = -scrollView.contentOffset.y
        var widthChange = view.frame.width + yDegree * 2
        widthChange = max(view.frame.width, widthChange)
        
        let imageView = userPhotosController.view!
        imageView.frame = CGRect(x: min(0,-yDegree), y: min(0,-yDegree), width: widthChange, height: widthChange + extraHeight)
    }
}

class UserDetailsController: UIViewController {
    var cardViewModel:CardViewModel! {
        didSet {
            self.userLabel.attributedText = cardViewModel.attributedText
            
            userPhotosController.cardViewModel = cardViewModel
            
            //            guard let firstImageURL = cardViewModel.userImageUrls.first, let url = URL(string: firstImageURL) else {
            //                return
            //            }
            
            
            //            imageView.sd_setImage(with: url)
        }
    }
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never // remove top padding of screen
        sv.delegate = self
        return sv
    }()
    
    let userPhotosController = UserSwipingPhotosController()
 
    let userLabel:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let dismissButton:UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "34").withRenderingMode(.alwaysOriginal), for: .normal)
        b.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return b
    }()
    
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "03_2"), selector: #selector(handleDislike))
    lazy var superlikeButton = self.createButton(image: #imageLiteral(resourceName: "03_3"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "03_4"), selector: #selector(handleDislike))
    
    fileprivate func createButton(image:UIImage,selector:Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        b.addTarget(self, action: selector, for: .touchUpInside)
        b.imageView?.contentMode = .scaleAspectFill
        return b
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        initLayout()
        setupBlurView()
        setupBottomButton()
    }
    
    fileprivate func setupBottomButton(){
        let sv = UIStackView(arrangedSubviews: [
            dislikeButton, superlikeButton,likeButton])
        sv.distribution = .fillEqually
        sv.spacing = -30
        scrollView.addSubview(sv)
        sv.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil,size: .init(width: 300, height: 80))
        
        sv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupBlurView(){
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        
        
    }
    
    
    fileprivate func initLayout() {
        scrollView.fillSuperview()
        
        let userPhotosControllerView = userPhotosController.view!
        
        scrollView.addSubview(userPhotosControllerView)
        
        // we use frame as it is hard to use autolayout with scrollview
        //        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        scrollView.addSubview(userLabel)
        
        userLabel.anchor(top: userPhotosControllerView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: userPhotosControllerView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,
                             padding: .init(top: -25, left: 0, bottom: 0, right: 24),
                             size: .init(width: 50, height: 50))
        
    }
    
    fileprivate let extraHeight:CGFloat = 80
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = userPhotosController.view!
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
    }
    
    
    
    // MARK: OBJC
    
    @objc fileprivate func handleTapDismiss(){
        self.dismiss(animated: true)
        print("here")
    }
    
    @objc fileprivate func handleDislike(){
        
    }
    
    
}
