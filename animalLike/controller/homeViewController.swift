//
//  homeViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import Koloda
import Firebase
import FirebaseUI


class homeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
  
    var kolodaArray: [PostData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
      }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
          if Auth.auth().currentUser != nil {
                // ログイン済み
                if listener == nil {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                    listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、kolodaArrayの配列にする。
                        self.kolodaArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        //kolodaArrayの配列から、画像データのみを抽出する
                        
                    }
            }
        }
        kolodaView.reloadData()
    }
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        print(kolodaArray.count)
        return kolodaArray.count
    }
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let imageView = UIImageView(frame: koloda.bounds)
        //画像の表示
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(kolodaArray[index].id + ".jpg")
        print(imageRef)
        imageView.sd_setImage(with: imageRef)
        koloda.addSubview(imageView)
        return imageView
    }
    
    //

    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .left:
            print("hidari")
            return
        case .right:
            print("migi")
           
            return
        default:
            return
            
        }
    }
    //画像が消え終わったときの処理
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("end")
        
    }
    
    @IBAction func badButton(_ sender: Any) {
    }
    
    @IBAction func likeButton(_ sender: Any) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
    }
    
}
