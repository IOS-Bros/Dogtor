//
//  UserDBModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/06.
//

import Foundation

class UserDBModel {
    
    static let user = UserDBModel()
    init(){}
    
    var userId : String?
    var API : String?
    var email : String?
    var image : String?
    var nickName : String?
    var imageURL : URL?
    
    init(API : String, email : String) {
        self.API = API
        self.email = email
    }
    // 20210805 - yejin
    init(nickName : String) {
    self.nickName = nickName
  }
  // --
}
