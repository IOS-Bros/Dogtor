//
//  CheckLoginModel.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/03.
//

import Foundation

// 값을 다른곳으로 줄때 쓰는것
protocol CheckLoginModelProtocol : class {
    func itemDownloaded(items : NSMutableArray)
}

class CheckLoginModel : NSObject {
   
    var delegate : CheckLoginModelProtocol!
    
    
    func checkUser(_ email : String) {
        let urlPath = "http://\(myURL):8080/dogtor/check_user.jsp?email=\(email)"
        print(urlPath)
        let url : URL = URL(string: urlPath)!
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data is downloaded")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ data : Data) {
        print("parseJSON")
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            print("gma?")
            jsonElement = jsonResult[i] as! NSDictionary
            if let email = jsonElement["email"] as? String,
               let API = jsonElement["API"] as? String {
                print("Model : \(email)")
                let query = UserDBModel(API: API, email: email)
                locations.add(query)
            }
        }
        // TableViewController 가 다른 일을 할때를 대비하여 async를 사용한다.
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
    
}
