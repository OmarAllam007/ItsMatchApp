//
//  SettingsController.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 11/08/2022.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage


protocol SettingsControllerDelegate {
    func didSaveSettings()
}


class CustomImagePicketController:UIImagePickerController {
    var imageButton:UIButton?
}




extension SettingsController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePicketController)?.imageButton
        imageButton?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath:"/images/\(filename)")
        guard let uploadedData = image?.jpegData(compressionQuality: 0.5) else { return }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading..."
        hud.show(in: view)
        
        ref.putData(uploadedData) { (nil, err) in
            
            
            if let err = err {
                hud.dismiss(animated: true)
                print(err)
                return
            }
            
            ref.downloadURL { url, err in
                hud.dismiss(animated: true)
                
                if let err = err {
                    print(err)
                    return
                }
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                }else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                }else{
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
}


class SettingsController: UITableViewController {

    lazy var image1Button = createImageButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createImageButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createImageButton(selector: #selector(handleSelectPhoto))
    
    
    var settignsDelegate:SettingsControllerDelegate?
    
    @objc func handleSelectPhoto(button:UIButton){
        let imagePicker = CustomImagePicketController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func createImageButton(selector:Selector) -> UIButton {
        let b  = UIButton(type: .system)
        b.setTitle("Select Photo", for: .normal)
        b.backgroundColor = .white
        b.imageView?.contentMode = .scaleAspectFill
        b.clipsToBounds = true
        b.layer.cornerRadius = 10
        b.addTarget(self, action: selector, for: .touchUpInside)
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigation()
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        
        fetchCurrentUser()
        
    }
    
    var user:User?
    fileprivate func fetchCurrentUser(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { snapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return }
            self.user = User(dictionary: dictionary)
            
            self.loadUserImages()
            self.tableView.reloadData()
        }
            
    }
    
    fileprivate func loadUserImages(){
        
        if let imageUrl = user?.imageUrl1 {
            if let url = URL(string: imageUrl){
                SDWebImageManager.shared.loadImage(with: url,options: .continueInBackground, progress: nil)
                { image, data, error, _, _, _ in
                    self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
        
        if let imageUrl = user?.imageUrl2 {
            if let url = URL(string: imageUrl){
                SDWebImageManager.shared.loadImage(with: url,options: .continueInBackground, progress: nil)
                { image, data, error, _, _, _ in
                    self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
        
        if let imageUrl = user?.imageUrl3 {
            if let url = URL(string: imageUrl){
                SDWebImageManager.shared.loadImage(with: url,options: .continueInBackground, progress: nil)
                { image, data, error, _, _, _ in
                        self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
        
    }
    
    
    lazy var header:UIView = {
        
        let header = UIView()
        header.addSubview(image1Button)
    
        let padding:CGFloat = 16
        
        image1Button.anchor(top: header.topAnchor,
                            leading: header.leadingAnchor,
                            bottom: header.bottomAnchor,
                            trailing: nil,
                            padding: .init(top: padding, left: padding, bottom: padding, right: 0)
        )
        
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button,image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor,padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }

        let headerLbl = HeaderLabel()
        switch section {
        case 1:
            headerLbl.text = "Name"
        case 2:
            headerLbl.text = "Profession"
        case 3:
            headerLbl.text = "Age"
        case 4:
            headerLbl.text = "Bio"
        default:
            headerLbl.text = "Age Range"
        }
        
        headerLbl.font = .boldSystemFont(ofSize: 14)
        
        return headerLbl
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return tableView.frame.height * 0.35
        }
        return 50
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    
    static let defaultMinAge = 18
    static let defaultMaxAge = 50
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // range cell
        if indexPath.section == 5 {
            let cell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            cell.minSlider.addTarget(self, action: #selector(handleMinSlide), for: .valueChanged)
            cell.maxSlider.addTarget(self, action: #selector(handleMaxSlide), for: .valueChanged)
            
            
            let minAge = user?.minAge ?? Self.defaultMinAge
            let maxAge = user?.maxAge ?? Self.defaultMaxAge
            cell.minLabel.text = "Min: \(minAge)"
            cell.maxLabel.text = "Max: \(maxAge)"
            cell.minSlider.value = Float(minAge)
            cell.maxSlider.value = Float(maxAge)
            return cell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Professsion"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            
            if let age = user?.age {
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }

        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    // MARK: @OBJC FUNCTIONS
    
    @objc fileprivate  func handleNameChange(textField:UITextField){
        self.user?.name = textField.text
    }
    
    @objc fileprivate  func handleProfessionChange(textField:UITextField){
        self.user?.profession = textField.text
    }
    
    
    @objc fileprivate  func handleAgeChange(textField:UITextField){
        self.user?.age = Int(textField.text ?? "0")
    }
    

    @objc func handleCancel()
    {
        dismiss(animated: true)
    }
    
    
    @objc func handleMinSlide(slider:UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        self.user?.minAge = Int(slider.value)
    }

    @objc func handleMaxSlide(slider:UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        self.user?.maxAge = Int(slider.value)
    }

    
    
    
    // MARK: Layout setup
    fileprivate func setupNavigation() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveUserInfo)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
            
        ]
    }
    
    @objc func handleLogout(){
        try? Auth.auth().signOut()
        dismiss(animated: true)
        
    }
    
    @objc func handleSaveUserInfo(){
        
       guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docData:[String:Any] = [
            "uid": uid,
            "fullName":user?.name ?? "",
            "imageUrl1":user?.imageUrl1 ?? "",
            "imageUrl2":user?.imageUrl2 ?? "",
            "imageUrl3":user?.imageUrl3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minAge":user?.minAge ?? -1,
            "maxAge":user?.maxAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            hud.dismiss(animated: true)
            if let err = error {
                print(err)
                return
            }
            
            self.dismiss(animated: true) {
                self.settignsDelegate?.didSaveSettings()
            }
            
            
        }
    }
}

class HeaderLabel:UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
