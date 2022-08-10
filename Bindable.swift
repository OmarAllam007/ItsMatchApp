//
//  Bindable.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 09/08/2022.
//

//Very important to understand
import Foundation

class  Bindable<T> {
    var value:T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer:((T?)->())?
    
    func bind(observer: @escaping (T?)->()){
        self.observer = observer
    }
}
