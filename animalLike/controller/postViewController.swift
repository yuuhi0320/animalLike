//
//  postViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/30.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase
import CLImageEditor

class postViewController: UIViewController, UITextFieldDelegate,UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {
    
    var image: UIImage!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 10
        commentTextField.delegate = self
        imageView.bringSubviewToFront(self.view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGesture)
    }

    @objc func tapped(){
            let actionSheet = UIAlertController(title: "", message: "写真を投稿しましょう！", preferredStyle: UIAlertController.Style.alert)
            let action1 = UIAlertAction(title: "カメラで撮影する", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.tappCamera()
            }
            let action2 = UIAlertAction(title: "ライブラリから選択する", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.tappLibrary()
            }
            let action3 = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.default) { (UIAlertAction) in
                print("cancel")
            }
            actionSheet.addAction(action1)
            actionSheet.addAction(action2)
            actionSheet.addAction(action3)
            present(actionSheet, animated: true, completion: nil)
    }
    
    
        func tappLibrary(){
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }
            
        func tappCamera(){
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                           let pickerController = UIImagePickerController()
                           pickerController.delegate = self
                           pickerController.sourceType = .camera
                           self.present(pickerController, animated: true, completion: nil)
            }
        }
    
    //写真及びライブラリ選択時に呼ぶメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            let image = info[.originalImage] as! UIImage
            print("後で加工する")
            //CLImageEditorにimageを渡して、加工画面を起動する
            let editor = CLImageEditor(image: image)
            editor!.delegate = self
            picker.present(editor!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    //climageeditarで画像加工
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! postViewController
        imageView.image = image
        imageView.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
        //UserDefaults.standard.set(image, forKey: "image")
        
    }
    //climageeditorキャンセル時
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func postButtonAction(_ sender: Any) {
        print(image as Any)
        //if UserDefaults.standard.object(forKey: "image") != nil {
          //  image = (UserDefaults.standard.object(forKey: "image") as! UIImage)
        //}
        image = imageView.image
        let imageData = image.jpegData(compressionQuality: 0.75)
       
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        SVProgressHUD.show()
        //オブジェクトのプロパティ。key-value値で保存
        let metaData = StorageMetadata()
        if let name = nameTextField.text, let comment = commentTextField.text {
            if name.isEmpty || comment.isEmpty {
                print("nameかcommentが入力されていません")
                SVProgressHUD.showError(withStatus: "nameかcommentが入力されていません")
                return
            }
        }
    //https://qiita.com/AkihiroTakamura/items/b93fbe511465f52bffaa
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            if error != nil {
                //画像のアップロードに失敗
                print("エラー")
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました。")
                //投稿処理をキャンセルして先頭(複数のviewControllerを一度に飛ばす)画面に戻る。
                UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController
        }
            
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": self.nameTextField.text,
                "caption": self.commentTextField.text,
                "date": FieldValue.serverTimestamp() ] as [String: Any]
            
            
            //setData > firebaseにデータを保存
            postRef.setData(postDic)
            SVProgressHUD.showSuccess(withStatus: "投稿に成功しました")
            //UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 0
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        commentTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
