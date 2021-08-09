//
//  LoginedUserInfo.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/05.
//  예진님에게 DTO 받고 주석처리부분 적용하면 됨

import Foundation


class LoginedUserInfo{
    static var loginedUserInfo: LoginedUserInfo? = nil
    var user = UserDBModel()
    
    //userMode: UserModel = UserModel()
    
    private init(){}
    
    static func getLoginedUserInfo() -> LoginedUserInfo{
        
        if loginedUserInfo == nil {
            loginedUserInfo = LoginedUserInfo()
        }
        
        return self.loginedUserInfo!
    }
    
    

}
