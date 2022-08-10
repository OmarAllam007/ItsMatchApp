//
//  RegisterationController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 02/08/2022.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD


extension RegisterationController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        vm.image.value = image
        
        dismiss(animated: true)
    }
}


class RegisterationController: UIViewController {
    
    
    
    
    let selectPhoto:UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Select Photo", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 32,weight: .heavy)
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.heightAnchor.constraint(equalToConstant: 275).isActive = true
        b.layer.cornerRadius = 15
        b.addTarget(self, action: #selector(handleSelectProfileImage), for: .touchUpInside)
        b.imageView?.contentMode = .scaleAspectFill
        b.clipsToBounds = true
        return b
    }()
    
    lazy var nameTF:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var emailTF:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter Email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTF:CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    
    lazy var registerButton:UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Register", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16,weight: .heavy)
        b.backgroundColor = .lightGray
        b.setTitleColor(.gray, for: .disabled)
        b.isEnabled = false
        b.heightAnchor.constraint(equalToConstant: 44).isActive = true
        b.layer.cornerRadius = 22
        b.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return b
    }()
    
    
    lazy var verticalStackView:UIStackView = {
        let sv =  UIStackView(arrangedSubviews: [
            nameTF,emailTF,passwordTF,registerButton
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 5
        return sv
    }()
    
    lazy var parentStackView = UIStackView(arrangedSubviews: [
        selectPhoto, verticalStackView
    ])
    
    
    
    
    let registerHud = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister(){
        self.handleTapDismissKeyboard()
       
        
        
        vm.performRegisteration { [weak self] error in
            if let error = error {
                self?.showHUDWithError(error: error)
                return
            }
             
            print("completed")
        }
        
    }
    
    fileprivate func showHUDWithError(error:Error){
        registerHud.dismiss(animated: true)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failure"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        
        hud.dismiss(afterDelay: 4)
        
    }
    
    
    @objc fileprivate func handleTextChange(tf:UITextField){
        if tf == nameTF {
            vm.name = tf.text
        } else if tf == emailTF {
            vm.email = tf.text
        } else if tf == passwordTF{
            vm.password = tf.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupGradientLayer()
        setupLayout()
        
        setupNotificationObserver()
        setupTapGesture()
        initObserverForm()
    }
    
    let vm = RegisterationViewModel()
    
    fileprivate func initObserverForm(){
        
        vm.bindableFormValid.bind { [unowned self] isValid in
            
            if let isValid = isValid {
                self.registerButton.isEnabled = isValid
                self.registerButton.backgroundColor = isValid ?  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : .lightGray
            }
            
        }
    
        vm.image.bind { [unowned self] image in
            self.selectPhoto.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        vm.bindableIsRegistering.bind {[unowned self] isRegistering in
            if isRegistering == true {
                self.registerHud.textLabel.text = "Register"
                self.registerHud.show(in: view)
            }else {
                self.registerHud.dismiss(animated: true)
            }
        }

    }
    
    fileprivate func setupTapGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismissKeyboard)))
    }
    
    fileprivate func setupNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisplay), name:
                                                UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDismissKeyboard), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleDismissKeyboard(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    @objc fileprivate func handleTapDismissKeyboard(){
        self.view.endEditing(true)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboardDisplay(notification:Notification){
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = frame.cgRectValue
        let bottomSpace = view.frame.height - parentStackView.frame.origin.y - parentStackView.frame.height
        
        let difference = keyboardFrame.height - bottomSpace
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 10)
        }
    }
    
    
   
    fileprivate func setupLayout() {
        view.addSubview(parentStackView)
        
        if self.traitCollection.verticalSizeClass == .compact {
            parentStackView.axis = .horizontal
            selectPhoto.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4)
                .isActive = true
        }else{
            parentStackView.axis = .vertical
        }
        
        
        selectPhoto.widthAnchor.constraint(equalToConstant: view.frame.width * 0.3)
            .isActive = true
        
        parentStackView.spacing = 8
        
        parentStackView.anchor(top: nil, leading: view.leadingAnchor,
                               bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        parentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        parentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //
        if self.traitCollection.verticalSizeClass == .compact {
            parentStackView.axis = .horizontal
            selectPhoto.widthAnchor.constraint(equalToConstant: view.frame.width * 0.3)
                .isActive = true
        }else{
            parentStackView.axis = .vertical
        }
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer(){
        
        let topColor = #colorLiteral(red: 1, green: 0.4528897405, blue: 0.4463171959, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    @objc fileprivate func handleSelectProfileImage(){
        
        DispatchQueue.main.async { [unowned self] in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true)
        }
        
        
    }
  

    
}
