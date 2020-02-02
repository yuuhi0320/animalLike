//
//  cmaraAndLibraryViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/29.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import CLImageEditor

class cmaraAndLibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate, CLImageEditorDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var cameraItem: UITabBarItem!
    @IBOutlet weak var libraryItem: UITabBarItem!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            print("1")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            }
            
        case 2:
            print("2")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        default:
            print("")
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
    
    @IBAction func backButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
       }
    
    //climageeditarで画像加工
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! postViewController
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    //climageeditorキャンセル時
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
