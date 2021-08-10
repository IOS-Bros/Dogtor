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
    var fHashTag: String
    
    //test용
    init (fNo: Int){
        self.fNo = fNo
        fContent = String(fNo)
        fWriter = "Greensky"
        self.fHashTag = "none"
    }
    
    //insert용 버전
    init(fContent: String, fWriter: String, imageURL: URL, hashTag: String) {
        self.fContent = fContent
        self.fWriter = fWriter
        self.imageURL = imageURL
        self.fHashTag = hashTag
    }
    
    
    //select시 image없는 초기 버젼
    init(fNo: Int, fSubmitDate: String, fContent: String, fWriter: String, fHashTag: String) {
        self.fNo = fNo
        self.fSubmitDate = fSubmitDate
        self.fContent = fContent
        self.fWriter = fWriter
        self.fHashTag = fHashTag
    }
    
    func printAllFromSelectModel(){
        print("fNo: \(fNo), fContent : \(fContent), fWriter : \(fWriter), fHashTag : \(fHashTag)")
    }
    
    func printAllFromInsertModel(){
        print("fContent : \(fContent), fWriter : \(fWriter), imageURL : \(imageURL!), fHashTag : \(fHashTag)")
    }
}
