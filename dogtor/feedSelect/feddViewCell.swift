//
//  feddViewCell.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import UIKit

class feddViewCell: UITableViewCell {
    
    var hashTagList = [String]()
    
    var no: Int?
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var submitDate: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet var hashTagCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hashTagCollectionView.delegate = self
        hashTagCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        var justDebugStr = ""
        for str in hashTagList {
            justDebugStr += "[\(str)]"
        }
        print(justDebugStr)
        // Configure the view for the selected state
    }

}

extension feddViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hashTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hashTagCollectionView.dequeueReusableCell(withReuseIdentifier: "feedHashTagCell", for: indexPath) as! HashTagCollectionViewCell
        
        cell.backgroundColor = .lightGray
        cell.lblHashTag.text = "#\(hashTagList[indexPath.row])"
        return cell
    }
}

extension feddViewCell: UICollectionViewDelegateFlowLayout{
    //좌우간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
