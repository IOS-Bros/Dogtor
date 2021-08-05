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
    
    //insert용 버전
    init(fContent: String, fWriter: String, imageURL: URL) {
        self.fContent = fContent
        self.fWriter = fWriter
        self.imageURL = imageURL
    }
    
    //image table load 후 합본 버전
    init(fno: Int, fSubmitDate: String, fContent: String, fWriter: String, imageName: String) {
        self.fNo = fno
        self.fSubmitDate = fSubmitDate
        self.fContent = fContent
        self.fWriter = fWriter
        self.imageName = imageName
    }
    
    //select시 image없는 초기 버젼
    init(fno: Int, fSubmitDate: String, fContent: String, fWriter: String) {
        self.fNo = fno
        self.fSubmitDate = fSubmitDate
        self.fContent = fContent
        self.fWriter = fWriter
    }
    
    func printAllFromInsertModel(){
        print("fContent : \(fContent), fWriter : \(fWriter), imageURL : \(imageURL!)")
    }
}
