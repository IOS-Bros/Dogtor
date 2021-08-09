//
//  FeedImageSelectAllModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/06.
//

import Foundation

protocol FeedImageSelectAllModelProtocol{
    func feedImageDownloaded(items: NSMutableArray)
}


class FeedImageSelectAllModel{
    var delegate: FeedImageSelectAllModelProtocol!
    let urlPath = "http://\(Common.ipAddr):8080//dogtor_temp/feed_image_select_all.jsp"
    
    func feedImageDownloaded(){
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
        if let returnData = String(data: data, encoding: .utf8) {
            print(returnData)
        } else {
            print("data is empty")
            
        }
        print("--------------------")
        
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
            if let no = jsonElement["fiNo"] as? String,
               let name = jsonElement["fiName"] as? String,
               let fNo = jsonElement["fNo"] as? String{
                let dto = FeedImageModel(no: Int(no)!, name: name, fNo: Int(fNo)!)
                dto.printAll()
                locations.add(dto)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.feedImageDownloaded(items: locations)
        })
    }//parseJSON
}
