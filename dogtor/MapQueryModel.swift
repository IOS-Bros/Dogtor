//
//  MapQueryModel.swift
//  dogtor
//
//  Created by SeungYeon on 2021/08/03.
//

import Foundation
// 불러올때필요한 프로토콜
//protocol JsonModelProtocol: class {
protocol MapQueryModelProtocol{
    func itemDownloaded(items: NSArray)
}

//class JsonModel:NSObject{
class MapQueryModel{
    var delegate: MapQueryModelProtocol!
    let urlPath = "http://192.168.2.9:8080/dogter/hospital_list_query.jsp"
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSesstion = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSesstion.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloaded")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            if let HospitalID = jsonElement["HospitalID"] as? String,
               let HospitalName = jsonElement["HospitalName"] as? String,
               let Location = jsonElement["Location"] as? String,
               let Lat = jsonElement["Lat"] as? String,
                let Long = jsonElement["Long"] as? String{
//                print(HospitalName, Lat, Long)
                let query = MapDBModel(HospitalID: HospitalID, HospitalName: HospitalName, Location: Location, Lat: Lat, Long: Long)
                locations.add(query)
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}

