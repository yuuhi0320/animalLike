//
//  tabBarViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/27.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import Firebase

class tabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていないときの処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is cameraViewController {
            let cameraAndLibraryViewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraAndLibrary")
            self.present(cameraAndLibraryViewController!, animated: true, completion: nil)
            
        }
    }
}
