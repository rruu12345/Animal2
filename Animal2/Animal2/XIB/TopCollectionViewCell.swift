//
//  TopCollectionViewCell.swift
//  Animal2
//
//  Created by 王一平 on 2019/9/20.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit

protocol DidClickHandler: AnyObject {
    func didClickHandler(item:Int)
}


class TopCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var collectionView: UICollectionView!

    var topKindArray: [String] = ["全部", "貓", "狗", "台北", "台南", "雲林", "高雄", "其它"]
    var screenFull = UIScreen.main.bounds.size
//    var didClickHandler: ((Int) -> ()) = { item in }
    var delegate:DidClickHandler?


    static var nib: UINib {
        return UINib(nibName: "TopCollectionViewCell", bundle: Bundle(for: self))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCell.nib, forCellWithReuseIdentifier: "TopCell")
        //top下邊線
        collectionView.layer.borderColor = UIColor(red: 77 / 255, green: 77 / 255, blue: 77 / 255, alpha: 0.3).cgColor
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
        return UIEdgeInsets(top: 20, left: 60 / 896 * screenFull.width, bottom: 0, right: 60 / 896 * screenFull.width)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topKindArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
        cell.configCellWithModel(top: topKindArray, i: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //點擊
        print("點擊\(indexPath.item + 1)")
//        didClickHandler(indexPath.item)
        delegate?.didClickHandler(item: indexPath.item)
    }
}
