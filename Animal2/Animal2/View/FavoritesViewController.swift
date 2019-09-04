//
//  FavoritesViewController.swift
//  Animal2
//
//  Created by 王一平 on 2019/8/29.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit
import RxSwift

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var waiting: UIActivityIndicatorView!
    
    var imageApi = ImageAPI()
    var row: Int = 0
    var loveArray: [String] = []
    var lovetry: [[String]] = []
    var lovetry2: [Int] = []

    let viewModel: AnimalViewModel = AnimalViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(OneCollectionViewCell.nib, forCellWithReuseIdentifier: "OneCollectionViewCell")
        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {

        loveArray = UserDefaults.standard.stringArray(forKey: "loveArray") ?? []
        if loveArray != [] as! [String] {
            lovetry = UserDefaults.standard.object(forKey: "lovetry") as! [[String]]
            lovetry2 = UserDefaults.standard.object(forKey: "lovetry2") as! [Int]
            self.waiting.alpha = 0
            self.waiting.stopAnimating()
            collectionView.reloadData()
        } else {
            print("oops")
        }
    }
    
    // 设置cell和视图边的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loveArray != [] as! [String] {
            return lovetry.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCollectionViewCell", for: indexPath) as! OneCollectionViewCell
        cell.configCellWithModelLove(kind: lovetry[indexPath.row][1], sex: lovetry[indexPath.row][2])

        if lovetry[indexPath.row][0] == "" { //無照片
            let image = UIImage(named: "yuki")
            cell.configCellImage(text: "無照片", image: image!, alpha: 0.5)
        } else { //有照片
            self.imageApi.GetImage(url: lovetry[indexPath.row][0]) { (image) in
                DispatchQueue.main.async {
                    cell.configCellImage(text: "", image: image, alpha: 1)
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //點擊

        //點擊圖片
        self.waiting.alpha = 1
        waiting.startAnimating()
        UserDefaults.standard.set(lovetry2[indexPath.row], forKey: "topnum")
        UserDefaults.standard.set(indexPath.row, forKey: "delete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.performSegue(withIdentifier: "showanimal", sender: self.lovetry[indexPath.row][3])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TwoViewController
        controller.ID = sender as? String
    }
}
