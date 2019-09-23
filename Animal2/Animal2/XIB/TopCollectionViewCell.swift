//
//  TopCollectionViewCell.swift
//  Animal2
//
//  Created by 王一平 on 2019/9/20.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var topKindArray: [String] = ["全部", "貓", "狗", "台北", "台南", "雲林", "高雄", "其它"]
    var screenFull = UIScreen.main.bounds.size

    
    static var nib: UINib {
        return UINib(nibName: "TopCollectionViewCell", bundle: Bundle(for: self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCell.nib, forCellWithReuseIdentifier: "TopCell")
        //top下邊線
        collectionView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //cell 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if screenFull.height >= 812 {
                return CGSize(width: 90 / 414 * screenFull.width, height: 115 / 896 * screenFull.height)
            } else {
                return CGSize(width: 72 / 375 * screenFull.width, height: 92 / 667 * screenFull.height)
            }
        }
    
    //cell 條目間距 橫向的左右間距，縱向的上下間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }
    
    //cell離邊的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 75 / 896 * screenFull.height, left: 60 / 896 * screenFull.width, bottom: 5 / 896 * screenFull.height, right: 60 / 896 * screenFull.width)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topKindArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
        cell.configCellWithModel(top: topKindArray, i: indexPath.item)
        return cell
    }
}
