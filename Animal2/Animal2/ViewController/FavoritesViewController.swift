//
//  FavoritesViewController.swift
//  Animal2
//
//  Created by on 2019/8/29.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var favoritesArray: [String] = []
    var favoritesData: [[String]] = []
    var favoritesIntData: [Int] = []
    var screenFull = UIScreen.main.bounds.size

    let viewModel: AnimalViewModel = AnimalViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(OneCell.nib, forCellWithReuseIdentifier: "OneCell")
        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        favoritesArray = UserDefaults.standard.stringArray(forKey: "favoritesArray") ?? []
        if favoritesArray != [] as! [String] {
            favoritesData = UserDefaults.standard.object(forKey: "favoritesData") as! [[String]]
            favoritesIntData = UserDefaults.standard.object(forKey: "favoritesIntData") as! [Int]
            collectionView.reloadData()
        } else {
            print("oops")
        }
    }

    //cell 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if screenFull.height >= 812 {
            return CGSize(width: 120 / 414 * screenFull.width, height: 200 / 896 * screenFull.height)
        } else {
            return CGSize(width: 99 / 375 * screenFull.width, height: 165 / 667 * screenFull.height)
        }
    }

    //cell離邊的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if screenFull.height >= 812 {
            return UIEdgeInsets(top: screenFull.height * 10 / 896, left: screenFull.width * 15 / 896, bottom: screenFull.height * 25 / 896, right: screenFull.width * 15 / 896)
        } else {
            return UIEdgeInsets(top: 10, left: 15, bottom: 25, right: 15)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoritesArray != [] as! [String] {
            return favoritesData.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCell", for: indexPath) as! OneCell
        cell.configCellWithModelLove(kind: favoritesData[indexPath.item][1], sex: favoritesData[indexPath.item][2])

        if favoritesData[indexPath.item][0] == "" { //無照片
            let image = UIImage(named: "yuki")
            cell.configCellImage(text: "無照片", image: image!, alpha: 0.5)
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
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //點擊

        //點擊圖片
        UserDefaults.standard.set(favoritesIntData[indexPath.item], forKey: "topClickNum")
        UserDefaults.standard.set(indexPath.item, forKey: "delete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.performSegue(withIdentifier: "showanimal", sender: self.favoritesData[indexPath.item][3])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TwoViewController
        controller.idStr = sender as? String
    }
}
