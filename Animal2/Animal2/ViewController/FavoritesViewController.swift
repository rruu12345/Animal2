//
//  FavoritesViewController.swift
//  Animal2
//
//  Created by on 2019/8/29.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLable: UILabel!

    private var favoritesData: [[String]] = []
    private var favoritesIntData: [Int] = []
    private var screenFull = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(OneCell.nib, forCellWithReuseIdentifier: "OneCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        favoritesData = UserDefaults.standard.object(forKey: "favoritesData") as? [[String]] ?? []
        favoritesIntData = UserDefaults.standard.object(forKey: "favoritesIntData") as? [Int] ?? []
        noDataLable.isHidden = favoritesData == [] ? false : true
        collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return screenFull.height >= 812 ? CGSize(width: 120 / 414 * screenFull.width, height: 200 / 896 * screenFull.height) : CGSize(width: 99 / 375 * screenFull.width, height: 165 / 667 * screenFull.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 25, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesData != [] ? favoritesData.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCell", for: indexPath) as! OneCell
        guard favoritesData != [] else { return cell }

        if favoritesData[indexPath.item][0] == "" { //無照片
            cell.configCellImage(text: "無照片", image: UIImage(named: "yuki")!, alpha: 0.5)
        } else { //有照片
            if let url = URL(string: favoritesData[indexPath.item][0]) {
                DispatchQueue.main.async {
                    UIImageView().kf.setImage(with: url, placeholder: UIImage(named: "yuki"), options: nil, progressBlock: nil) { (result) in
                        switch result {
                        case .success(let success):
                            cell.configCellImage(text: "", image: success.image, alpha: 1)
                        case .failure(_):
                            break
                        }
                    }
                }
            }
        }
        cell.configCellWithModelLove(kind: favoritesData[indexPath.item][1], sex: favoritesData[indexPath.item][2])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tabbarVC = self.tabBarController else { return }
        let tabbarListVC = tabbarVC.viewControllers?[0] as! OneViewController
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwoViewController") as! TwoViewController
        vc.idStr = favoritesData[indexPath.item][3]
        vc.delete = indexPath.item
        vc.topClickNum = favoritesIntData[indexPath.item]
        vc.mAnimalData = tabbarListVC.mAnimalData
        present(vc, animated: true, completion: nil)
    }
}
