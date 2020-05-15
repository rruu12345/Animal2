//
//  ShowAnimalViewController.swift
//
//  Created by  on 2019/8/8.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class TwoViewController: UIViewController {

    internal let viewModel = AnimalViewModel()
    internal var delete: Int!
    internal var idStr: String!
    internal var arrayNum: Int!
    internal var topClickNum: Int!
    internal var mAnimalData: [AnimalModel]!

    private var favoritesData: [[String]] = {
        return UserDefaults.standard.object(forKey: "favoritesData") as? [[String]] ?? []
    }()
    private var favoritesIntData: [Int] = {
        return UserDefaults.standard.object(forKey: "favoritesIntData") as? [Int] ?? []
    }()

    @IBOutlet var views: TwoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        uiText()
        imageGet()
        buttonImage()
    }

    @IBAction func backController(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func favorites(_ sender: Any) {
        if arrayNum == nil { // 資料被刪除了
            views.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
        } else { // 資料沒被刪除唷
            let favoritesArray = [mAnimalData[arrayNum].album_file, mAnimalData[arrayNum].animal_kind, mAnimalData[arrayNum].animal_sex, mAnimalData[arrayNum].animal_subid]

            if favoritesData == [] as! [[String]] { // no favoritesData 先收藏再說
                views.favorites.setImage(UIImage(named: "favorites_choose"), for: .normal)
                favoritesData.append(favoritesArray)
                favoritesIntData.append(topClickNum)
            } else {
                //有data 判斷刪或儲
                var aaa = true
                for i in 0..<favoritesData.count {
                    if favoritesData[i][3].contains(mAnimalData[arrayNum].animal_subid) { // 刪除唷
                        aaa = false
                        views.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
                        favoritesData.remove(at: i)
                        favoritesIntData.remove(at: i)
                        break
                    }
                }
                if aaa { // 添加唷
                    views.favorites.setImage(UIImage(named: "favorites_choose"), for: .normal)
                    favoritesData.append(favoritesArray)
                    favoritesIntData.append(topClickNum)
                }
            }
            UserDefaults.standard.set(favoritesData, forKey: "favoritesData")
            UserDefaults.standard.set(favoritesIntData, forKey: "favoritesIntData")
        }
    }

    /// 判斷愛心的圖片&無資料
    private func buttonImage() {
        if favoritesData == [] as! [[String]] {
            print("image no data")
        } else if arrayNum == nil { //資料被系統刪除了
            views.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
            favoritesData.remove(at: delete)
            favoritesIntData.remove(at: delete)
            UserDefaults.standard.set(favoritesData, forKey: "favoritesData")
            UserDefaults.standard.set(favoritesIntData, forKey: "favoritesIntData")
        } else {
            for i in 0..<favoritesData.count {
                if favoritesData[i][3].contains(mAnimalData[arrayNum].animal_subid) { // 已收藏
                    views.favorites.setImage(UIImage(named: "favorites_choose"), for: .normal)
                    break
                } else { // 未收藏
                    views.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
                }
            }
        }
    }

    /// text的資料
    private func uiText() {
        for i in 0..<mAnimalData.count {
            let animal = mAnimalData[i]
            if animal.animal_subid == idStr {
                views.sex.text = "性別：\(viewModel.animalString(string: animal.animal_sex))"
                views.colour.text = "花色：\(animal.animal_colour)"
                views.openDate.text = "入所日期：\(animal.animal_opendate)"
                views.kind.text = "種類：\(animal.animal_kind)"
                views.bodytype.text = "體型：\(viewModel.animalString(string: (animal.animal_bodytype)))"
                views.remark.text = "描述：\(animal.animal_remark)"
                views.subid.text = "ID：\(animal.animal_subid)"
                views.sName.text = "收容所名稱：\(animal.shelter_name)"
                views.sAddress.text = "地址：\(animal.shelter_address)"
                views.sTel.text = "電話：\(animal.shelter_tel)"
                arrayNum = i
            }
        }
    }

    /// image的圖片
    private func imageGet() {
        views.imageView.image = UIImage(named: "yuki")
        views.imageView.alpha = 0.5
        if arrayNum == nil {
            views.image_lable.text = "資料已被刪除"
        } else {
            let animal = mAnimalData[arrayNum]
            if animal.album_file == "" {
                views.image_lable.text = "無照片"
            } else {
                if let url = URL(string: animal.album_file) {
                    views.imageView.kf.setImage(with: url)
                    views.image_lable.text = ""
                    views.imageView.alpha = 1
                }
            }
        }
    }
}
