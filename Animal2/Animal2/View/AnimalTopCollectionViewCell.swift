//
//  AnimalTopCollectionViewCell.swift
//  Animal2
//
//  Created by on 2019/9/20.
//  Copyright © 2019. All rights reserved.
//

import UIKit

protocol DidClickHandler: AnyObject {
    func didClickHandler(item: Int)
}

class AnimalTopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    private let screenFull = UIScreen.main.bounds.size
    private var topKindArray: [String] = ["全部", "貓", "狗", "台北", "台南", "台中", "高雄", "其它"]
    internal var delegate: DidClickHandler?

    static var nib: UINib {
        return UINib(nibName: "AnimalTopCollectionViewCell", bundle: Bundle(for: self))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TopCell.nib, forCellWithReuseIdentifier: "TopCell")
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 3)
        collectionView.layer.shadowRadius = 3
        collectionView.layer.shadowOpacity = 0.3
        collectionView.layer.masksToBounds = false
    }
}

extension AnimalTopCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72 / 375 * screenFull.width, height: 92 / 667 * screenFull.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 60 / 896 * screenFull.width, bottom: 0, right: 60 / 896 * screenFull.width)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topKindArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCell", for: indexPath) as! TopCell
        cell.configCellWithModel(imageStr: topKindArray[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didClickHandler(item: indexPath.item)
    }
}
