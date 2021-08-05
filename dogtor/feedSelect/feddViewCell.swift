//
//  feddViewCell.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import UIKit

class feddViewCell: UITableViewCell {
    
    var no: Int?
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var writerImage: UIImageView!
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var submitDate: UILabel!
    @IBOutlet weak var content: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
