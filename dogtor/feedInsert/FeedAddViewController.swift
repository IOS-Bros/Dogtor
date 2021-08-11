//
//  FeedAddViewController.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import UIKit

class FeedAddViewController: UIViewController {
    
    var hashTagList = [String]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet var hastTagCollectionView: UICollectionView!
    @IBOutlet var tfHashTag: UITextField!
    
    let picker = UIImagePickerController()
    var imageURL: URL?
    var entranceToken = 0
    //##########임시##############
    var writer = "greenSky"
    //###########################
    var deliveredFeedModel: FeedModel?
    var deliveredFeedImageModle: FeedImageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //?? 플레이스홀더 어케쓴거야
        hastTagCollectionView.delegate = self
        hastTagCollectionView.dataSource = self
        picker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        if entranceToken == 1 {
            loadData()
        }
    }
    
    //FeedViewController의 FeedListTable cell 클릭으로 이동했을경우 실행
    func recieveItems(feedModel: FeedModel, feedImageModel: FeedImageModel){
        deliveredFeedModel = feedModel
        deliveredFeedImageModle = feedImageModel
        entranceToken = 1
    }
    
    //전달받은 값으로 뷰 아이템에 값 채워줌
    func loadData(){
        guard let feedDto = deliveredFeedModel else {
            needMoreDataAlert(3)
            navigationController?.popViewController(animated: true)
            return
        }
        tvContent.text = feedDto.fContent
        
        let hashTagStrs = feedDto.fHashTag
        if hashTagStrs != "none"  {
            hashTagList.removeAll()
            let splitedHashTags = hashTagStrs.split(separator: " ")
            for hashTag in splitedHashTags {
                hashTagList.append(String(hashTag))
            }
            hastTagCollectionView.reloadData()
        }
        
        guard let feedImageDto = deliveredFeedImageModle else {
            return
        }
        let imagePath = feedImageDto.imagePath
        if imagePath.isEmpty { return }
        guard let url = URL(string: imagePath) else { return }
        imageView.kf.setImage(with: url)
    }
    
    //해시태그 추가 버튼
    @IBAction func btnAddHashTag(_ sender: UIButton) {
        //비었을경우 아무 작업없이 반환
        if tfHashTag.text?.isEmpty ?? true {
            return
        }
        
        guard let spiltedHastTagInput = tfHashTag.text?.split(separator: " ") else {
            return
        }
        
        if spiltedHastTagInput.count == 1 {
            hashTagList.append(String(spiltedHastTagInput[0]))
        } else {
            for hashTag in spiltedHastTagInput {
                hashTagList.append(String(hashTag))
            }
        }
        tfHashTag.text?.removeAll()
        hastTagCollectionView.reloadData()
        
        var justDebugStr = ""
        for str in hashTagList {
            justDebugStr += "[\(str)]"
        }
        print(justDebugStr)
    }
    
    //이미지 터치시 이미지 업로드할 수 있도록 alter 출력
    @objc func imageTapped() {
        let alter = UIAlertController(title: "사진 업로드", message: nil, preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "사진앨범", style: .default, handler: {ACTION in self.openGallery()})
        let camera = UIAlertAction(title: "카메라", style: .default, handler: {ACTION in self.openCamera()})
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alter.addAction(gallery)
        alter.addAction(camera)
        alter.addAction(cancel)
        
        present(alter, animated: true, completion: nil)
    }
    
    //Done button
    @IBAction func barBtnInsert(_ sender: UIBarButtonItem) {
        guard let imageURL = imageURL  else {
            needMoreDataAlert(1)
            return
        }
        guard let _ = tvContent.text else {
            needMoreDataAlert(0)
            return
        }
        
        let fContent = tvContent.text.replacingOccurrences(of: "\n", with: "[__empty_space__]")
        let fWriter = writer.trimmingCharacters(in: .whitespacesAndNewlines)
        var fHashTag = "none"
        if hashTagList.count >= 1 {
            fHashTag = ""
            for hashTag in hashTagList {
                fHashTag += "\(hashTag) "
            }
            fHashTag = fHashTag.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        var feedModel: FeedModel
        var feedUploadModel: FeedUploadModel
        
        if entranceToken == 1 {
            feedUploadModel = FeedUploadModel(type: "update")
            feedModel = deliveredFeedModel!
            deliveredFeedModel!.imageURL = imageURL
            deliveredFeedModel!.fContent = fContent
            deliveredFeedModel!.fHashTag = fHashTag
            print("[try upadate]")
            feedModel.printAllFromSelectModel()
        } else {
            feedUploadModel = FeedUploadModel(type: "insert")
            feedModel = FeedModel(fContent: fContent, fWriter: fWriter, imageURL: imageURL, hashTag: fHashTag)
            print("[try insert]")
            feedModel.printAllFromInsertModel()
        }
        
        feedUploadModel.uploadImageFile(feedModel: feedModel, completionHandler: {data, res, error in
            print("Feed Upload Done")
            //옵셔널 제거해서 done 과 같다면 정상적으로 수행 else라면 수행 실패
            let dataToStr = String(data: data!, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let _ = dataToStr else {
                self.needMoreDataAlert(2)
                return
            }
            if error != nil {
                self.needMoreDataAlert(2)
                return
            }
            DispatchQueue.main.async {() -> Void in
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    //이미지 갤러리 오픈
    func openGallery(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    //카메라 열기
    func openCamera(){
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is not available")
            return
        }
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    //선택지가 하나인 Alter 묶음 : 리팩토링시 별도 클래스에 선언해 사용할것
    func needMoreDataAlert(_ type: Int){
        var title = ""
        var msg = ""
        if type == 0 {
            title = "내용이 없습니다."
            msg = "내용 입력은 필수입니다."
        } else if type == 1 {
            title = "이미지가 없습니다."
            msg = "이미지 업로드는 필수입니다."
        } else if type == 2{
            title = "이미지 업로드에 실패했습니다."
            msg = "인터넷 연결상태를 확인해 주세요."
        } else {
            title = "데이터 로드에 실패했습니다."
            msg = "인터넷 연결상태를 확인해 주세요."
        }
        
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionDefault = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(actionDefault)
        present(alert, animated: true, completion: nil)
    }

} //FeedAddViewController

//MARK: extension
//갤러리나 카메라에서 이미지 선택시의 델리게이트
extension FeedAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            //업로드에 사용할 url
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
        }
        dismiss(animated: true, completion: nil)
    }
}

//HashTag collection view 델리게이트 및 데이터소스
extension FeedAddViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = hastTagCollectionView.dequeueReusableCell(withReuseIdentifier: "hashTagCell", for: indexPath) as! FeedAddCollectionViewCell
        
        cell.backgroundColor = .lightGray
        cell.lblHashTag.text = "#\(hashTagList[indexPath.row])"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hashTagList.remove(at: indexPath.row)
        hastTagCollectionView.deleteItems(at: [indexPath])
        var justDebugStr = ""
        for str in hashTagList {
            justDebugStr += "[\(str)]"
        }
        print(justDebugStr)
    }

    
}

extension FeedAddViewController: UICollectionViewDelegateFlowLayout{
    //좌우간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
