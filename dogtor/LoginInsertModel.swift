//
//  LoginInsertModel.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/02.
//

import Foundation


class LoginInsertModel: NSObject {
    
    var urlPath = "http://\(myURL):8080/dogtor/user_google_insert.jsp"
    
    func insertGoogle(_ google : String, _ userEmail : String, _ userImage : URL, _ userNicName : String) -> Bool {
        var result : Bool = true
        let urlAdd = "?google=\(google)&userEmail=\(userEmail)&userImage=\(userImage)&userNickName=\(userNicName)"
        
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        print(urlPath)
        
        let url : URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Failed to insert data")
                result = false
            } else {
                print("Data is inserted!")
                result = true
            }
            
        }
        task.resume()
        return result
    }
}
