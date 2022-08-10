//
//  RegisterationViewModel.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 03/08/2022.
//

import UIKit
import Firebase

class RegisterationViewModel{
    var bindableIsRegistering = Bindable<Bool>()
    var image = Bindable<UIImage>()
    
    var name:String? {
        didSet{
            checkForm()
        }
    }
    var email:String? {
        didSet{
            checkForm()
        }
    }
    var password:String? {
        didSet{checkForm()}}

    
    
    func performRegisteration(completion: @escaping (Error?)->()){
        guard let email = email, let password = password else {
            return
        }
        
        self.bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { res, error in
            if let error = error {
                completion(error)
                return
            }
            
            
            self.saveImageToStorage(completion: completion)
            
            
        }
    }
    
    fileprivate func saveImageToStorage(completion: @escaping (Error?)->()){
        let filename = UUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.image.value?.jpegData(compressionQuality: 0.5) ?? Data()
        
        storageRef.putData(imageData,metadata: nil) { _, error in
            
            if let err = error {
                completion(err)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let err = error {
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                let url = url?.absoluteString ?? ""
                
                self.saveUserInfoToFireStore(imageUrl: url, completion: completion)
                
//                completion(nil)
            }
            
        }
    }
    
    
    fileprivate func saveUserInfoToFireStore(imageUrl:String,completion:@escaping (Error?)->()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let userDoc = ["fullname":name ?? "","uid":uid,"imageUrl1":imageUrl]
        
        Firestore.firestore().collection("users").document(uid).setData(userDoc) { error in
            if let err = error{
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    
    fileprivate func checkForm(){
        let isValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableFormValid.value = isValid
    }
    
    var bindableFormValid = Bindable<Bool>()
    
    
}
