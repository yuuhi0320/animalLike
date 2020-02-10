//
//  rankingViewController.swift
//  animalLike
//
//  Created by 木村旭 on 2020/01/26.
//  Copyright © 2020 asahi.kimura. All rights reserved.
//

import UIKit

class rankingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let collectionTitles = ["Day", "Week", "AllDay"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "RankingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RankingCollectionViewCell")
        
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)
        flowLayout.minimumInteritemSpacing = self.collectionView.frame.size.width/6
        collectionView.collectionViewLayout = flowLayout
        
        
        }
    
        
    

    
    }

extension rankingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingCollectionViewCell", for: indexPath) as? RankingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.titleLabel.text = collectionTitles[indexPath.row]
        return cell
    }
    
    
}

extension rankingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rankingTableViewCell", for: indexPath) as? rankingTableViewCell else { return UITableViewCell() }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.size.height / 10
    }
}
