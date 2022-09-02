//
//  Match.swift
//  ItsMatchApp
//
//  Created by Omar Khaled on 31/08/2022.
//

import Foundation

struct MatchModel {
    let name,profileImageUrl,uid:String
    
    
    init(dict:[String:Any]) {
        self.name = dict["name"] as? String ?? ""
        self.profileImageUrl = dict["profileImageUrl"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
    }
    
}
