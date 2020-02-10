//
//  rankingTableViewCell.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit
import FirebaseUI


class rankingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    func setPostData(_ postData: PostData){
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        imageView?.sd_setImage(with: imageRef)
        //likeの数
        let likeNUmber = postData.likes.count
        likeNumberLabel.text = "\(likeNUmber)"
    }
 
}
