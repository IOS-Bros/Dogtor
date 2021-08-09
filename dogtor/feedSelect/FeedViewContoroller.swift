//  FeedViewContorollerViewController.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.

import UIKit
import Kingfisher

var feedDicWithNo = [Int: UITableViewCell]()

class FeedViewContoroller: UIViewController {

    @IBOutlet weak var feedListTableView: UITableView!
    var feedItem: NSMutableArray = NSMutableArray()
    var feedImageItem: NSMutableArray = NSMutableArray()
    var lastFeedNo = 0
    
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
    }
    
    //인피니트 스크롤시 스피너
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
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

// MARK: - Extiension
extension FeedViewContoroller: FeedSelectAllModelProtocol{
    func feedDownloaded(items: NSMutableArray) {
        feedItem = items
        
        //마지막으로 로드한 fno를 구함
        let arraySize = feedItem.count
        let dto = feedItem[arraySize - 1] as! FeedModel
        lastFeedNo = dto.fNo!
        
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
        
        cell.no = item.fNo
        self.lastFeedNo = item.fNo!
        cell.writerName.text = item.fWriter
        cell.submitDate.text = item.fSubmitDate
        cell.content.text = item.fContent
        
        //이미지 검색
        loadImage(item: item, cell: cell)

        
        
        print("\(indexPath.row)번째 셀의 데이터")
        item.printAllFromSelectModel()
        
        //cell 생성시 dic에 추가
        feedDicWithNo[cell.no!] = cell
        
        return cell
    }
    
    func loadImage(item: FeedModel, cell: feddViewCell) {
        DispatchQueue.global().async {
            var imagePath: String?
            
            for imageDTO in self.feedImageItem {
                let dto = imageDTO as! FeedImageModel
                if item.fNo == dto.fNo {
                    imagePath = dto.imagePath
                }
            }
            guard let _ = imagePath else { return }
            guard let url = URL(string: imagePath!) else { return }
            DispatchQueue.main.async {
                cell.feedImage.kf.setImage(with: url)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if position > (contentHeight - scrollView.frame.size.height - 200) {
            self.feedListTableView.tableFooterView = createSpinnerFooter()
            
            for i in 0...5{
                lastFeedNo += 1
                let dto = FeedModel(fNo: lastFeedNo)
                feedItem.add(dto)
            }
            print(lastFeedNo)
            DispatchQueue.main.async() {
                self.feedListTableView?.tableFooterView = nil
            }
            
        }
        
    }
}//FeedViewContoroller: UITableViewDelegate, UITableViewDataSource
