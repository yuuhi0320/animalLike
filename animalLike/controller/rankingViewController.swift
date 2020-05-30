//
//  rankingViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class rankingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    //投稿データに保存する配列
    var postArray: [PostData] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //カスタムセルを登録する
        let nib = UINib(nibName: "rankingTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "rankingTableViewCell")
  
        tableView.delegate = self
        tableView.dataSource = self
        //可変式
        tableView.rowHeight = UITableView.automaticDimension
        //
        tableView.estimatedRowHeight = 75
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
             // ログイン済み
              if listener == nil {
                 // listener未登録なら、登録してスナップショットを受信する
                  let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "likes", descending: true)
                  listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                     if let error = error {
                         print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                         return
                     }
                     // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                     self.postArray = querySnapshot!.documents.map { document in
                         print("DEBUG_PRINT: document取得 \(document.documentID)")
                         let postData = PostData(document: document)
                         return postData
                     }
                     // TableViewの表示を更新する
                     self.tableView.reloadData()
                  }
              }
          }
        
    }
    
    @IBAction func segChangeControllAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            dayRank()
        case 1:
            weekRank()
        case 2:
            AllRank()
        default:
            print("aaa")
        }
    }
    
    func dayRank(){
        
    }
    func weekRank(){
        
    }
    func AllRank(){
        
    }
    
}

func convertTimeStamp(serverTimerStamp: CLong) -> String{
    let x = serverTimerStamp / 1000
    let date = Date(timeIntervalSince1970: TimeInterval(x))
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    return formatter.string(from: date)
}

extension rankingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rankingTableViewCell", for: indexPath) as? rankingTableViewCell else { return UITableViewCell() }
        cell.setPostData(postArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
