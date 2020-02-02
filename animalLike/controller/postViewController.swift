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


class postViewController: UIViewController {
    
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image

    }
    @IBAction func postButtonAction(_ sender: Any) {
        let imageData = image.jpegData(compressionQuality: 0.75)
       //https://qiita.com/1amageek/items/d606dcee9fbcf21eeec6
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        SVProgressHUD.show()
        //オブジェクトのプロパティ。key-value値で保存
        let metaData = StorageMetadata()
        //https://qiita.com/AkihiroTakamura/items/b93fbe511465f52bffaa
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            if let error = error {
                //画像のアップロードに失敗
                print("エラー")
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました。")
                //投稿処理をキャンセルして先頭(複数のviewControllerを一度に飛ばす)画面に戻る。
                
                UIApplication.shared.windows.first{ $0.isKeyWindow}?.rootViewController
        }
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
            "name": name,
            "caption": self.commentTextField.text,
            "date": FieldValue.serverTimestamp() ] as [String: Any]
            
            //setData > firebaseにデータを保存
            postRef.setData(postDic)
            SVProgressHUD.showSuccess(withStatus: "投稿に成功しました")
            UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 2
        }
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
