//
//  FeedModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/05.
//

import Foundation

class FeedModel{
    var fNo: Int?
    var fSubmitDate: String?
    var fContent: String
    var fWriter: String
    var imageName: String?
    var imageURL: URL?
    
    //test용
    init (fNo: Int){
        self.fNo = fNo
        fContent = String(fNo)
        fWriter = "Greensky"
        
    }
    
    //insert용 버전
    init(fContent: String, fWriter: String, imageURL: URL) {
        self.fContent = fContent
        self.fWriter = fWriter
        self.imageURL = imageURL
    }
    
    //image table load 후 합본 버전
    init(fNo: Int, fSubmitDate: String, fContent: String, fWriter: String, imageName: String) {
        self.fNo = fNo
        self.fSubmitDate = fSubmitDate
        self.fContent = fContent
        self.fWriter = fWriter
        self.imageName = imageName
    }
    
    //select시 image없는 초기 버젼
    init(fNo: Int, fSubmitDate: String, fContent: String, fWriter: String) {
        self.fNo = fNo
        self.fSubmitDate = fSubmitDate
        self.fContent = fContent
        self.fWriter = fWriter
    }
    
    func printAllFromSelectModel(){
        print("fNo: \(fNo), fContent : \(fContent), fWriter : \(fWriter)")
    }
    
    func printAllFromInsertModel(){
        print("fContent : \(fContent), fWriter : \(fWriter), imageURL : \(imageURL!)")
    }
}
