//
//  FeedAddViewController.swift
//  dogtor
//
//  Created by 윤재필 on 2021/08/04.
//

import UIKit

class FeedAddViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tvContent: UITextView!
    
    let picker = UIImagePickerController()
    var imageURL: URL?
    //##########임시##############
    var writer = "greenSky"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //?? 플레이스홀더 어케쓴거야
        //tvContent.placeholder = "내용을 입력해주세요!"
        
        picker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

    }
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
    
    @IBAction func barBtnInsert(_ sender: UIBarButtonItem) {
        guard let imageURL = imageURL  else {
            needMoreDataAlert(1)
            return
        }
        guard let _ = tvContent.text else {
            needMoreDataAlert(0)
            return
        }
        
        let feedUploadModel = FeedUploadModel()
        let feedModel = FeedModel(fContent: tvContent.text, fWriter: writer, imageURL: imageURL)
        feedModel.printAllFromInsertModel()
        feedUploadModel.uploadImageFile(feedModel: feedModel, completionHandler: {_, _ in
            print("Feed Upload Done")
        })
    }
    
    func openGallery(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is not available")
            return
        }
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    func needMoreDataAlert(_ type: Int){
        var title = ""
        var msg = ""
        if type == 1 {
            title = "이미지가 없습니다."
            msg = "이미지 업로드는 필수입니다."
        } else {
            title = "내용이 없습니다."
            msg = "내용 입력은 필수입니다."
        }
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionDefault = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(actionDefault)
        present(alert, animated: true, completion: nil)
    }

} //FeedAddViewController

//MARK: extension

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
