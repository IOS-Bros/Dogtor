//
//  FeedSelectAllModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import Foundation

protocol FeedSelectAllModelProtocol{
    func feedDownloaded(items: NSMutableArray)
}

class FeedSelectAllModel{
    var delegate: FeedSelectAllModelProtocol!
    let urlPath = "http://172.30.1.1:8080/ios/feed_select_all.jsp"
    
    func feedDownloaded(){
        guard let url: URL = URL(string: urlPath) else {
            print("feedDownloaded() : URL is not avilable")
            return
        }
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url){(data, responds, error) in
            if error != nil{
                print("Failed to download data")
            } else {
                print("Data is download")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }//feedDownloaded
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError {
            print(error)
        }
        
        var jsonElement = NSDictionary()
        var locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let fNo = jsonElement["fNo"] as? Int,
               let fSubmitDate = jsonElement["fSubmitDate"] as? String,
               let fContent = jsonElement["fContent"] as? String,
               let fWriter = jsonElement["fWriter"] as? String{
                let dto = feedModel(no: fNo, submitDate: fSubmitDate, content: fContent, writer: fWriter)
                locations.add(dto)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.feedDownloaded(items: locations)
        })
    }//parseJSON
}//FeedSelectAllModel