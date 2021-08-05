//
//  FeedViewContorollerViewController.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import UIKit

class FeedViewContorollerViewController: UIViewController {

    @IBOutlet weak var feedListTableView: UITableView!
    var feedItem: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //이후 수정
        feedListTableView.rowHeight = 400
        feedListTableView.estimatedRowHeight = 400

        feedListTableView.delegate = self
        feedListTableView.dataSource = self
        
        let FeedSelectAllModel = FeedSelectAllModel()
        FeedSelectAllModel.delegate = self
        FeedSelectAllModel.feedDownloaded()
        
        feedListTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FeedViewContorollerViewController: FeedSelectAllModelProtocol{
    func feedDownloaded(items: NSMutableArray) {
        feedItem = items
        self.feedListTableView.reloadData()
    }
    
    
}

// MARK: - Table view data source

extension FeedViewContorollerViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedListTableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! feddViewCell
        
        let item: feedModel = feedItem[indexPath.row] as! feedModel
        
        /*
         @IBOutlet weak var feedImage: UIImageView!
         @IBOutlet weak var writerImage: UIImageView!
         @IBOutlet weak var writerName: UILabel!
         @IBOutlet weak var submitDate: UILabel!
         @IBOutlet weak var content: UILabel!
         */
        
        cell.no = item.fNo
        cell.writerName.text = item.fWriter
        cell.submitDate.text = item.fSubmitDate
        cell.content.text = item.fContent
        
        print("\(indexPath.row)번째 셀의 데이터")
        item.printAll()
        
        return cell
    }
    
    
    
}
