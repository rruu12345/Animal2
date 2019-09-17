//
//  ShowAnimalViewController.swift
//  GameAB2
//
//  Created by 王一平 on 2019/8/8.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class TwoViewController: UIViewController {

    var delete: Int!
    var ID: String!
    var arrayNum: Int!
    var topClickNum: Int!
    var mAnimalData: [AnimalModel]!
    var animaldata: [AnimalModel]!
    var bag: DisposeBag! = DisposeBag()
    var favoritesArray: [String] = {
        return UserDefaults.standard.stringArray(forKey: "favoritesArray") ?? []
    }()
    var favoritesData: [[String]] = {
        return UserDefaults.standard.object(forKey: "favoritesData") as? [[String]] ?? []
    }()
    var favoritesIntData: [Int] = {
        return UserDefaults.standard.object(forKey: "favoritesIntData") as? [Int] ?? []
    }()
    let viewModel: AnimalViewModel = AnimalViewModel()

    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var image_lable: UILabel!
    @IBOutlet weak var subid: UILabel!
    @IBOutlet weak var colour: UILabel!
    @IBOutlet weak var opendate: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var bodytype: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var sname: UILabel!
    @IBOutlet weak var saddress: UILabel!
    @IBOutlet weak var stel: UILabel!
    @IBOutlet weak var sex: UILabel!
    @IBOutlet weak var favorites: UIButton!
    @IBOutlet weak var waiting: UIActivityIndicatorView!

    @IBAction func favorites(_ sender: Any) {
        if waiting.alpha == 1 {
            print("等等啦")
        } else if arrayNum == nil {
            print("資料被刪除了")
            self.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
        } else {
            favoritesArray = ["\(mAnimalData[arrayNum].album_file)", "\(mAnimalData[arrayNum].animal_kind)", "\(mAnimalData[arrayNum].animal_sex)", "\(mAnimalData[arrayNum].animal_subid)"]
            UserDefaults.standard.set(favoritesArray, forKey: "favoritesArray")
            print("收藏了喔喔喔")

            if favoritesData == [] as! [[String]] {
                print("no favoritesData 先收藏再說")
                self.favorites.setImage(UIImage(named: "Favorites choose"), for: .normal)
                favoritesData.append(favoritesArray)
                favoritesIntData.append(topClickNum)
                UserDefaults.standard.set(favoritesData, forKey: "favoritesData")
                UserDefaults.standard.set(favoritesIntData, forKey: "favoritesIntData")
            } else {
                //有data 判斷刪或儲
                var aaa = 0
                for i in 0...(favoritesData.count - 1) {
                    if favoritesData[i][3].contains(mAnimalData[arrayNum].animal_subid) {
                        aaa = 1
                        print("刪除唷")
                        self.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
                        favoritesData.remove(at: i)
                        favoritesIntData.remove(at: i)
                        UserDefaults.standard.set(favoritesData, forKey: "favoritesData")
                        UserDefaults.standard.set(favoritesIntData, forKey: "favoritesIntData")
                        break
                    }
                }
                if aaa == 0 {
                    print("添加唷")
                    self.favorites.setImage(UIImage(named: "Favorites choose"), for: .normal)
                    favoritesData.append(favoritesArray)
                    favoritesIntData.append(topClickNum)
                    print(favoritesData)
                    print(favoritesIntData)
                    UserDefaults.standard.set(favoritesData, forKey: "favoritesData")
                    UserDefaults.standard.set(favoritesIntData, forKey: "favoritesIntData")
                }
            }
        }
    }

    //返回鍵
    @IBAction func backcontroller(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.waiting.alpha = 1
        self.waiting.startAnimating()
        topClickNum = UserDefaults.standard.integer(forKey: "topClickNum")
        animalApiRequest()
    }

    deinit {
        UserDefaults.standard.removeObject(forKey: "topClickNum")
        print("釋放topClickNum")
    }

    //判斷愛心的圖片&無資料
    func buttonImage() {
        if favoritesData == [] as! [[String]] {
            print("image no data")
            self.waiting.alpha = 0
        } else if arrayNum == nil {//資料被系統刪除了
            self.waiting.alpha = 0
            delete = UserDefaults.standard.integer(forKey: "delete")
            self.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
            favoritesData.remove(at: delete)
            favoritesIntData.remove(at: delete)
            UserDefaults.standard.set(favoritesData, forKey: "favoritesData")
            UserDefaults.standard.set(favoritesIntData, forKey: "favoritesIntData")
        } else {
            var aaa = 0
            self.waiting.alpha = 0
            for i in 0...(favoritesData.count - 1) {
                if favoritesData[i][3].contains(mAnimalData[arrayNum].animal_subid) {
                    print("已收藏")
                    aaa = 1
                    self.favorites.setImage(UIImage(named: "Favorites choose"), for: .normal)
                }
            }
            if aaa == 0 {
                print("未收藏")
                self.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
            }
        }
    }

    //取值
    func animalApiRequest() {
        viewModel.requestAnimalData().subscribe(onNext: { [weak self] (result) in
            guard result else { return }
            guard let `self` = self else { return }
            self.animaldata = self.viewModel.All
            self.whichData()
            self.uiText()
            self.imageGet()
            self.buttonImage()
            print("api ok")
        }, onError: { (Error) in
            print("fuckkkkkkkk:\(Error)")
        }, onCompleted: {
            print("data get")
        }, onDisposed: nil
        ).disposed(by: bag)
    }

    //text的資料
    func uiText() {
        for i in 0...(mAnimalData.count - 1) {
            let animal = self.mAnimalData[i]
            if animal.animal_subid == ID {
                self.sex.text = "性別：\(self.animalString(string: animal.animal_sex))"
                self.colour.text = "花色：\(animal.animal_colour)"
                self.opendate.text = "入所日期：\(animal.animal_opendate)"
                self.kind.text = "種類：\(animal.animal_kind)"
                self.bodytype.text = "體型：\(self.animalString(string: (animal.animal_bodytype)))"
                self.remark.text = "描述：\(animal.animal_remark)"
                self.subid.text = "ID：\(animal.animal_subid)"
                self.sname.text = "收容所名稱：\(animal.shelter_name)"
                self.saddress.text = "地址：\(animal.shelter_address)"
                self.stel.text = "電話：\(animal.shelter_tel)"
                arrayNum = i
            }
        }
        print(arrayNum)
    }

    //image的圖片
    func imageGet() {
        if (self.mAnimalData == nil) || (self.ID == nil) { //拿不到data
            self.image_lable.text = "載入中"
            self.image.image = UIImage(named: "yuki")
            self.image.alpha = 0.5
        } else { //拿到data了
            if arrayNum == nil {
                self.image_lable.text = "資料已被刪除"
                self.image.image = UIImage(named: "yuki")
                self.image.alpha = 0.5
            } else {
                let animal = self.mAnimalData[arrayNum]

                if animal.album_file == "" {
                    self.image_lable.text = "無照片"
                    self.image.image = UIImage(named: "yuki")
                    self.image.alpha = 0.5
                } else {
                    if let url = URL(string: animal.album_file) {
                        self.image.kf.setImage(with: url)
                        self.image_lable.text = ""
                        self.image.alpha = 1
                    }
                }
            }
        }
    }

//資料英文轉中文
    func animalString(string: String) -> String {
        var out: String!
        if string == "M" {
            out = "男生"
        } else if string == "F" {
            out = "女生"
        } else if string == "SMALL" {
            out = "小型"
        } else if string == "MEDIUM" {
            out = "中型"
        } else if string == "BIG" {
            out = "大型"
        } else {
            out = string
        }
        return out
    }

//判斷是拿哪個資料
    func whichData() {
        switch self.topClickNum {
        case 0:
            self.mAnimalData = animaldata
            break
        case 1:
            self.mAnimalData = viewModel.cat
            break
        case 2:
            self.mAnimalData = viewModel.dog
            break
        case 3:
            self.mAnimalData = viewModel.taipei
            break
        case 4:
            self.mAnimalData = viewModel.Tainan
            break
        case 5:
            self.mAnimalData = viewModel.Yunlin
            break
        case 6:
            self.mAnimalData = viewModel.Kaohsiung
            break
        case 7:
            self.mAnimalData = viewModel.another
            break
        default:
            self.topClickNum = 0
            break
        }
    }
}
