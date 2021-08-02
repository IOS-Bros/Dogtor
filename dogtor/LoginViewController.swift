//
//  LoginViewController.swift
//  dogtor
//
//  Created by 예쁘고 비싼 thㅡ레기 on 2021/08/02.
//

import UIKit
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnGoogle(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "619955076758-7f30hc5sr2ses6ioljsco1uqgat4hbv4.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }

            // If sign in succeeded, display the app's main content View.
          }
    }
    
    @IBAction func btnKaKao(_ sender: UIButton) {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    UserApi.shared.me(completion: { (user, error) in
                        if let error = error {
                                print(error)
                            }
                            else {
                                print("me() success.")
                                print("\(user?.kakaoAccount?.profile!)")
                                print("\(user?.kakaoAccount?.email!)")

                                //do something
                                _ = user
                            }
                    })
                    //do something
//                    _ = oauthToken
                }
            }
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
