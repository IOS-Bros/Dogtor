//
//  feedModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import Foundation

class feedModel{
    var fNo:Int
    var fSubmitDate: String
    var fContent: String
    var fWriter: String
    var fImages: [String]?
    
    init(no: Int, submitDate: String, content: String, writer: String){
        self.fNo = no
        self.fSubmitDate = submitDate
        self.fContent = content
        self.fWriter = writer
    }
    init(no: Int, submitDate: String, content: String, writer: String, images: [String]){
        self.fNo = no
        self.fSubmitDate = submitDate
        self.fContent = content
        self.fWriter = writer
        self.fImages = images
    }
    
    func printAll(){
        print("no : \(fNo), date : \(fSubmitDate), content : \(fContent), writer : \(fWriter)")
    }
}
