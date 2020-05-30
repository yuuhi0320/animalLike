//
//  rankingTableViewCell.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase


class rankingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var rankingNumber: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPostData(_ postData: PostData){
        //いいねの順番
        let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "likes", descending: true)
        print(postsRef)
        rankingNumber.text = "\(postsRef)"
        
        //画像の表示
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        imageView?.sd_setImage(with: imageRef)
        //likeの数
        let likeNUmber = postData.likes.count
        likeNumberLabel.text = "\(likeNUmber)"
        print(likeNUmber)
    }
 
}
