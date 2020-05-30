//
//  registerViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/27.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import Firebase

class registerViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassweordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        addressTextField.delegate = self
        passwordTextField.delegate = self
        confirmPassweordTextField.delegate = self
    }
    
    @IBAction func registerButton(_ sender: Any) {
               if let userName = userNameTextField.text,
                   let address = addressTextField.text,
                   let password = passwordTextField.text,
                   let confirmPassword = confirmPassweordTextField.text {
                   //アカウントとパスワードと表示名がいずれも入力されていない場合
                   if userName.isEmpty || address.isEmpty || password.isEmpty ||  confirmPassword.isEmpty {
                       print("debug//何かが入力されていません")
                       return
                       //パスワードと確認用パスワードが入力されていない場合
                   } else if password != confirmPassword {
                       print("debug_パスワードが一致しません")
                       return
                   }
                   //アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動ログインする。
                   Auth.auth().createUser(withEmail: address, password: password) { (authResult, error) in
                       if let error = error {
                           print("debug//" + error.localizedDescription)
                           return
                       }
                       print("ユーザー作成に成功しました。")
                       //表示名を設定する
                       let user = Auth.auth().currentUser
                       if let user = user {
                           let changeRequest = user.createProfileChangeRequest()
                           changeRequest.displayName = userName
        //                   let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                           self.dismiss(animated: true, completion: nil)
                           //(homeViewController!, animated: true, completion: nil)
                       }
                   }
               }
           }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassweordTextField.resignFirstResponder()
    }
    
    @IBAction func backButton(_ sender: Any) {dismiss(animated: true, completion: nil)
    }
    
}
