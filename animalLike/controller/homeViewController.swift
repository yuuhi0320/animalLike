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
    var postData: PostData? //PostDataを追加
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        if Auth.auth().currentUser != nil {
                        // ログイン済み
                        if listener == nil {
                            // listener未登録なら、登録してスナップショットを受信する
                            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                            //classのプロパティをクロージャー内で使うとき、メモリを食うので[weak self]と記述する。
                            listener = postsRef.addSnapshotListener() { [weak self] (querySnapshot, error) in
                                guard let weakSelf = self else { return } //optionalをunwapする
                                if let error = error {
                                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                                    return
                                }
                                // 取得したdocumentをもとにPostDataを作成し、kolodaArrayの配列にする。
                                weakSelf.kolodaArray = querySnapshot!.documents.map { document in
                                    print("DEBUG_PRINT: document取得 \(document.documentID)")
                                    let postData = PostData(document: document)
                                    return postData
                                }
                                
                            //    command //
        //                        let intArray = [100,200,300,400,500]
        //                        let taxedArray = intArray.map { (number) -> Float in
        //                            return Float(number) * 1.01
        //                        }
                                //kolodaArrayの配列から、画像データのみを抽出する
                                weakSelf.kolodaView.reloadData()
                            }
                    }
                }
        
      }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
          if Auth.auth().currentUser != nil {
                // ログイン済み
                if listener == nil {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                    //classのプロパティをクロージャー内で使うとき、メモリを食うので[weak self]と記述する。
                    listener = postsRef.addSnapshotListener() { [weak self] (querySnapshot, error) in
                        guard let weakSelf = self else { return } //optionalをunwapする
                        if let error = error {
                            print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、kolodaArrayの配列にする。
                        weakSelf.kolodaArray = querySnapshot!.documents.map { document in
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        
                    //    command //
//                        let intArray = [100,200,300,400,500]
//                        let taxedArray = intArray.map { (number) -> Float in
//                            return Float(number) * 1.01
//                        }
                    
                        weakSelf.kolodaView.reloadData()
                    }
            }
        }
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
         print(kolodaArray.count)
        return kolodaArray.count
    }
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        postData = kolodaArray[index]
        let imageView = UIImageView(frame: koloda.bounds)
        //画像の表示
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(kolodaArray[index].id + ".jpg")
        print(imageRef)
        imageView.sd_setImage(with: imageRef)
        koloda.addSubview(imageView)
        return imageView
    }

    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .left:

            print("hidari：likeのカウントを取らない")
            return
        case .right:
            print("migi：likeのカウントする")
            postLike()
            return
        default:
            return
            
        }
    }
    //画像が消え終わったときの処理
<<<<<<< HEAD
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("end")
    }
=======
//    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        print("end")
//        koloda.resetCurrentCardIndex()
//    }
>>>>>>> d671e86fb24c1c45376b20321686627cb62682aa
    
    @IBAction func badButton(_ sender: Any) {
        kolodaView.swipe(.left)
        print("左")
    }
    
    @IBAction func likeButton(_ sender: Any) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        // likesを更新する
        postLike()
        kolodaView.swipe(.right)
        print("右")
    }
    
    /// いいねを登録する
    func postLike() {
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            guard let postData = postData else { return }
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
}
