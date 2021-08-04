//
//  LoginInsertViewController.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/02.
//

import UIKit

class LoginInsertViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfNicName: UITextField!
    
    var receiveGoogle : String = ""
    var receiveUserEmail : String = ""
    var receiveUserImageURL : URL?
    
    var userNicName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginInsertViewController")
//        let url = URL(string: receiveUserImage)
        do {
            let data = try Data(contentsOf: receiveUserImageURL!)
            imageView.image = UIImage(data: data)
        } catch { }

        
        tfNicName.text = receiveUserEmail
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFinish(_ sender: UIBarButtonItem) {
        print("btnFinish")
        userNicName = tfNicName.text!
        
        let loginInsertModel = LoginInsertModel()
        let result = loginInsertModel.insertGoogle(receiveGoogle, receiveUserEmail, receiveUserImageURL!, userNicName)
        
        if result {
            let resultAlert = UIAlertController(title: "완료", message: "입력이 되었습니다", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
            
        } else {
            let resultAlert = UIAlertController(title: "완료", message: "에러가 발생 되었습니다", preferredStyle: .alert)
            let onAction = UIAlertAction(title: "OK", style: .default, handler: {ACTION in
                self.navigationController?.popViewController(animated: true)
            })
            
            resultAlert.addAction(onAction)
            present(resultAlert, animated: true, completion: nil)
        }
    }
    
    
    
    
    func receiveUserInfo(_ google : String, _ userEmail : String, _ userImageURL : URL) {
        self.receiveGoogle = google
        self.receiveUserEmail = userEmail
        self.receiveUserImageURL = userImageURL
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
