//
//  FeedImageModel.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/06.
//

import Foundation

class FeedImageModel{
    var fiNo: Int
    var fiName: String
    var imagePath: String
    var fNo: Int
    
    init(no: Int, name: String, fNo: Int){
        self.fiNo = no
        self.fiName = name
        self.imagePath = Common.feedImagePath + name
        self.fNo = fNo
    }
    
    func printAll(){
        print("fiNo : \(fiNo), fiName : \(fiName), fNo : \(fNo)")
    }
}
