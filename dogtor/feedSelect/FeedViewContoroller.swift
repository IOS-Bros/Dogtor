//  FeedViewContorollerViewController.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.

import UIKit
import Kingfisher

class FeedViewContoroller: UIViewController {

    @IBOutlet weak var feedListTableView: UITableView!
    var feedItem: NSMutableArray = NSMutableArray()
    var feedImageItem: NSMutableArray = NSMutableArray()
    
    //####################################
    let loginedUserid = "greenSky"
    //####################################
    
    
    // MARK: - function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //이후 수정
        feedListTableView.rowHeight = 400
        feedListTableView.estimatedRowHeight = 400

        feedListTableView.delegate = self
        feedListTableView.dataSource = self
        
        tableDataLoad()
    } //viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        tableDataLoad()
    } //viewWillAppear
    
    func tableDataLoad(){
        let feedSelectAllModel = FeedSelectAllModel()
        feedSelectAllModel.delegate = self
        feedItem.removeAllObjects()
        feedImageItem.removeAllObjects()
        feedSelectAllModel.feedDownloaded()
        initRefresh()
    }
    
    //아래로 당겨서 리프레시
    func initRefresh(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        
        if #available(iOS 10.0, *){
            feedListTableView.refreshControl = refresh
        } else {
            feedListTableView.addSubview(refresh)
        }
    }
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        feedListTableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "modifyFeedSegue"{
            let cell = sender as! feddViewCell // 몇번째 cell 인지
            let detailView = segue.destination as! FeedAddViewController
            detailView.recieveItems(feedModel: cell.feedModel!, feedImageModel: cell.feedImageModel!)
            print("[feedModel]")
            cell.feedModel?.printAllFromSelectModel()
            print("---------------------------")
            print("[feedImageModel]")
            cell.feedImageModel?.printAll()
        }
    }
    
}

// MARK: - Extiension
extension FeedViewContoroller: FeedSelectAllModelProtocol{
    func feedDownloaded(items: NSMutableArray) {
        feedItem = items
        
        //데이터를 로드한 후 이미지를 불러온다
        let feedImageSeelectAllModel = FeedImageSelectAllModel()
        feedImageSeelectAllModel.delegate = self
        feedImageSeelectAllModel.feedImageDownloaded()
        
    }
}
extension FeedViewContoroller: FeedImageSelectAllModelProtocol{
    func feedImageDownloaded(items: NSMutableArray) {
        feedImageItem = items
        //이미지 로드가 끝난 후 테이블 리로드
        self.feedListTableView.reloadData()
    }
}

// MARK: - Table view data source

extension FeedViewContoroller: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedListTableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! feddViewCell
        
        let item: FeedModel = feedItem[indexPath.row] as! FeedModel
        
        cell.feedModel = item
        cell.writerName.text = item.fWriter
        cell.submitDate.text = item.fSubmitDate
        cell.content.text = item.fContent
        
        let hashTagStrs = item.fHashTag
        cell.hashTagList.removeAll()
        if hashTagStrs == "none" {
            
        } else {
            let splitedHashTags = hashTagStrs.split(separator: " ")
            for hashTag in splitedHashTags {
                cell.hashTagList.append(String(hashTag))
            }
            cell.hashTagCollectionView.reloadData()
        }
        
        //이미지 검색
        loadImage(item: item, cell: cell)
        print("\(indexPath.row)번째 셀의 데이터")
        item.printAllFromSelectModel()
        
        //선택시 회색배경처리되는거 제거
        cell.selectionStyle = .none
        
        return cell
    }
    
    func loadImage(item: FeedModel, cell: feddViewCell) {
        DispatchQueue.global().async {
            var imagePath: String?
            
            for imageDTO in self.feedImageItem {
                let dto = imageDTO as! FeedImageModel
                if item.fNo == dto.fNo {
                    imagePath = dto.imagePath
                    cell.feedImageModel = dto
                }
            }
            guard let _ = imagePath else { return }
            guard let url = URL(string: imagePath!) else { return }
            DispatchQueue.main.async {
                cell.feedImage.kf.setImage(with: url)
            }
        }
    }
}//FeedViewContoroller: UITableViewDelegate, UITableViewDataSource
