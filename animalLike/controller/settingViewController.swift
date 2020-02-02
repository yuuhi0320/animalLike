//
//  settingViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import Firebase

class settingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let contentsArray = ["プロフィール","利用規約","ログアウト"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contentsArray[indexPath.row]
        return cell
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentsArray[indexPath.row] {
        case "プロフィール" :
            let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! profileViewController
            present(profileViewController, animated: true, completion: nil)
        case "ログアウト":
            try?Auth.auth().signOut()
            UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.dismiss(animated: true, completion: nil)
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! loginViewController
            present(loginViewController, animated: true, completion: nil)
            
        default:
            print("")
        }
    }

}
