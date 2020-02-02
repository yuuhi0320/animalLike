//
//  loginViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         }
    //ログインボタンタップ時
    @IBAction func loginButton(_ sender: Any) {
        if let address = addressTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text {
            if address.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                print("何処か空です")
                return 
        }
            Auth.auth().signIn(withEmail: address, password: password, completion: { (user, error) in
                if let error = error {
                    print("Debug" + error.localizedDescription)
                    return
                }
                    print("ログイン成功")
                UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                self.tabBarController?.selectedIndex = 0
                })
            }
    }
    
    //アカウント作成ボタンタップ時
    @IBAction func accountButton(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Register")
            present(registerViewController!, animated: true, completion: nil)
        
    }
    
    
}
