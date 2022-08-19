//
//  UserSwipingPhotosController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 16/08/2022.
//

import UIKit

extension UserSwipingPhotosController:UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentVC = viewControllers?.first
        
        if let index = controllers.firstIndex(where: {$0 == currentVC}){
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
        
        
    }
}

extension UserSwipingPhotosController:UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    
}
class UserSwipingPhotosController: UIPageViewController {
    var controllers = [UIViewController]()
    
    fileprivate let isCardViewMode:Bool
    
    init(isCardViewMode:Bool = false){
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cardViewModel:CardViewModel! {
        didSet{
            controllers = cardViewModel.userImageUrls.map({ (imageUrl) -> UIViewController in
                return UserImageController(imageUrl: imageUrl)
            })
            
            setViewControllers([controllers.first!], direction: .forward, animated: false)
            
            setupBarViews()
        }
    }
    
    let barsStackView = UIStackView(arrangedSubviews: [])
    let deselectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupBarViews(){
        cardViewModel.userImageUrls.forEach { imageUrl in
            let barView = UIView()
            barView.backgroundColor = deselectedColor
            barView.layer.cornerRadius = 2
            barsStackView.spacing = 5
            barsStackView.distribution = .fillEqually
            barsStackView.addArrangedSubview(barView)
        }
        
        view.addSubview(barsStackView)
        
        var customPaddingTop:CGFloat = 8
        
        if !isCardViewMode {
            customPaddingTop = setStatusBarHeight() + 8
        }
        
        
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding:.init(top: customPaddingTop, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 4))
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if isCardViewMode {
            disableSwipeAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    @objc fileprivate func handleTap(gesture:UITapGestureRecognizer){
        
        let currentController = viewControllers!.first!
        
        barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedColor})
        
        if let index = controllers.firstIndex(of: currentController) {
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: true)
                
                
                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            }else{
                let prevIndex = max(0, index - 1)
                let prevController = controllers[prevIndex]
                setViewControllers([prevController], direction: .forward, animated: true)
        
                barsStackView.arrangedSubviews[prevIndex].backgroundColor = .white
            }
        }
    }
                                  
                                  
    fileprivate func disableSwipeAbility(){
        view.subviews.forEach { v in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    func setStatusBarHeight() -> CGFloat {
        let statusBarFrame: CGFloat
        
        if #available(iOS 13.0, *) {
            statusBarFrame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame.height
        }
        
        return statusBarFrame
    }
   

}

class UserImageController:UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_image2"))
    
    init(imageUrl:String){
        if let url = URL(string: imageUrl){
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image:UIImage){
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
