//
//  ShowAnimalViewController.swift
//  GameAB2
//
//  Created by 王一平 on 2019/8/8.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit
import RxSwift

class TwoViewController: UIViewController {

    var row: Int!
    var topnum: Int!
    var animaldata: [AnimalModel]!
    var animaldata2: [AnimalModel]!
    var bag: DisposeBag! = DisposeBag()
    var imageApi = ImageAPI()
    var loveArray: [String] = {
        return UserDefaults.standard.stringArray(forKey: "loveArray") ?? []
    }()
    var row2: [Int] = {
        return UserDefaults.standard.array(forKey: "row2") as? [Int] ?? []
    }()
    var lovetry: [[String]] = {
        return UserDefaults.standard.object(forKey: "lovetry") as? [[String]] ?? []
    }()
    var lovetry2: [[Int]] = {
        return UserDefaults.standard.object(forKey: "lovetry2") as? [[Int]] ?? []
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
    @IBOutlet weak var wait: UIImageView!

    @IBAction func favorites(_ sender: Any) {
        //if else &資料加入收藏夜
        loveArray = ["\(animaldata[row].album_file)", "\(animaldata[row].animal_kind)", "\(animaldata[row].animal_sex)", "\(animaldata[row].animal_subid)"]
        row2 = [row, topnum]
        UserDefaults.standard.set(loveArray, forKey: "loveArray")
        UserDefaults.standard.set(row2, forKey: "row2")
        print("收藏了喔喔喔")

        if lovetry == [] as! [[String]] {
            self.favorites.setImage(UIImage(named: "Favorites choose"), for: .normal)
            print("nodata")
            lovetry.append(loveArray)
            lovetry2.append(row2)
            print(lovetry)
            print(lovetry2)
            UserDefaults.standard.set(lovetry, forKey: "lovetry")
            UserDefaults.standard.set(lovetry2, forKey: "lovetry2")
        } else {
            print("有data")
            var aaa = 0
            for i in 0...(lovetry.count - 1){
                if lovetry[i][3].contains(animaldata[row].animal_subid) {
                    aaa = 1
                    print("刪除唷")
                    self.favorites.setImage(UIImage(named: "Favorites"), for: .normal)
                    lovetry.remove(at: i)
                    lovetry2.remove(at: i)
                    print(lovetry)
                    print(lovetry2)
                    UserDefaults.standard.set(lovetry, forKey: "lovetry")
                    UserDefaults.standard.set(lovetry2, forKey: "lovetry2")
                    break
                }
            }
            if aaa == 0{
                print("添加唷")
                self.favorites.setImage(UIImage(named: "Favorites choose"), for: .normal)
                lovetry.append(loveArray)
                lovetry2.append(row2)
                print(lovetry)
                print(lovetry2)
                UserDefaults.standard.set(lovetry, forKey: "lovetry")
                UserDefaults.standard.set(lovetry2, forKey: "lovetry2")
            }
        }
    }
    
    //判斷愛心的圖片
    func buttonImage(){
        if lovetry == [] as! [[String]]{
            print("image no data")
        } else{
            var aaa = 0
            for i in 0...(lovetry.count - 1){
                if lovetry[i][3].contains(animaldata[row].animal_subid) {
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
    
    //返回鍵
    @IBAction func backcontroller(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    deinit {
        UserDefaults.standard.removeObject(forKey: "topnum")
        print("釋放topnum")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.wait.alpha = 1
        topnum = UserDefaults.standard.integer(forKey: "topnum")
        animalApiRequest()
    }

    //取直
    func animalApiRequest() {
        viewModel.requestAnimalData().subscribe(onNext: { [weak self] (result) in
            guard result else { return }
            guard let `self` = self else { return }
            self.animaldata2 = self.viewModel.All
            self.whichData()
            self.uiText()
            self.imageGet()
            self.buttonImage()
            print("data get")
        }, onError: { (Error) in
            print("fuckkkkkkkk:\(Error)")
        }, onCompleted: {
            print("api ok")
        }, onDisposed: nil
        ).disposed(by: bag)
    }

    //text的資料
    func uiText() {
        let animal = self.animaldata[self.row]
        self.sex.text = "性別：\(self.animalString(S: animal.animal_sex))"
        self.colour.text = "花色：\(animal.animal_colour)"
        self.opendate.text = "入所日期：\(animal.animal_opendate)"
        self.kind.text = "種類：\(animal.animal_kind)"
        self.bodytype.text = "體型：\(self.animalString(S: (animal.animal_bodytype)))"
        self.remark.text = "描述：\(animal.animal_remark)"
        self.subid.text = "ID：\(animal.animal_subid)"
        self.sname.text = "收容所名稱：\(animal.shelter_name)"
        self.saddress.text = "地址：\(animal.shelter_address)"
        self.stel.text = "電話：\(animal.shelter_tel)"
    }

    //image的圖片
    func imageGet() {
        if (self.animaldata == nil) || (self.row == nil) {
            print("image no~")
        } else {
            print("image Get")
            self.wait.image = nil
            let animal = self.animaldata[self.row]
            imageApi.GetImage(url: animal.album_file) { (image) in
                DispatchQueue.main.async {
                    self.image.image = UIImage(named: "yuki") } }
            if animal.album_file != "" {
                self.imageApi.GetImage(url: animal.album_file) { (image) in
                    DispatchQueue.main.async {
                        self.image_lable.text = ""
                        self.image.image = image
                        self.image.alpha = 1
                    }
                }
            }
        }
    }

    //資料英文轉中文
    func animalString(S: String) -> String {
        var out: String!
        if S == "M" {
            out = "男生"
        } else if S == "F" {
            out = "女生"
        } else if S == "SMALL" {
            out = "小型"
        } else if S == "MEDIUM" {
            out = "中型"
        } else if S == "BIG" {
            out = "大型"
        } else {
            out = S
        }
        return out
    }

    //判斷是拿哪個資料
    func whichData() {
        switch self.topnum {
        case 0:
            self.animaldata = animaldata2
            break
        case 1:
            self.animaldata = viewModel.cat
            break
        case 2:
            self.animaldata = viewModel.dog
            break
        case 3:
            self.animaldata = viewModel.taipei
            break
        case 4:
            self.animaldata = viewModel.Tainan
            break
        case 5:
            self.animaldata = viewModel.Yunlin
            break
        case 6:
            self.animaldata = viewModel.Kaohsiung
            break
        case 7:
            self.animaldata = viewModel.another
            break
        default:
            self.topnum = 0
            break
        }
    }
}
