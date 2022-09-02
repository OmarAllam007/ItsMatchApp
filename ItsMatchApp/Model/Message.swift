//
//  Message.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 29/08/2022.
//

import Foundation
import Firebase

struct Message {
    let text,fromId,toId:String
    let timestamp:Timestamp
    let isAuthUserMessage:Bool
    
    init(dictionary:[String:Any]){
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isAuthUserMessage = Auth.auth().currentUser?.uid == self.fromId
    }
}
