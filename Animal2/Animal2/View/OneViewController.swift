//
//  OneViewController.swift
//  Animal2
//
//  Created by 王一平 on 2019/8/29.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit
import RxSwift

class OneViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var BotcollectionView: UICollectionView!
    @IBOutlet weak var TopcollectionView: UICollectionView!
    @IBOutlet weak var landing: UIImageView!
    @IBOutlet weak var waiting: UIActivityIndicatorView!
    
    var bag: DisposeBag! = DisposeBag()
    var animaldata: [AnimalModel]!
    var animaldata2: [AnimalModel]!
    var count: Int!
    var arrayCount: Int!
    var top: [String] = ["全部", "貓", "狗", "台北", "台南", "雲林", "高雄", "其它"]
    var topnum: Int!
    var imageApi = ImageAPI()

    let viewModel: AnimalViewModel = AnimalViewModel()

    deinit {
        bag = nil
    }

    override func viewDidLoad() { // ->1
        super.viewDidLoad()
        self.landing.alpha = 1
        //top下邊線
        self.TopcollectionView.layer.borderColor = UIColor.lightGray.cgColor

        BotcollectionView.register(OneCollectionViewCell.nib, forCellWithReuseIdentifier: "OneCollectionViewCell")
        TopcollectionView.register(TopCollectionViewCell.nib, forCellWithReuseIdentifier: "TopCollectionViewCell")
        animalApiRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        whichData()
        self.waiting.stopAnimating()
        self.waiting.alpha = 0
        BotcollectionView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //->3
        if collectionView == self.TopcollectionView {
            return top.count
        } else {
            if (self.arrayCount != nil) {
                self.count = self.arrayCount
            } else {
                self.count = 12
            }
            return self.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //->4
        if collectionView == self.TopcollectionView { //top
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
            cell.configCellWithModel(top: top, i: indexPath.row)
            return cell
        } else { //bottom
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCollectionViewCell", for: indexPath) as! OneCollectionViewCell
            if self.count > 12 { //取到資料
                whichData()
                let data = self.animaldata[indexPath.row]
                cell.configCellWithModel(i: indexPath.row, model: animaldata)
                if data.album_file == "" { //無照片
                    let image = UIImage(named: "yuki")
                    cell.configCellImage(text: "無照片", image: image!, alpha: 0.5)
                } else { //有照片
                    self.imageApi.GetImage(url: data.album_file) { (image) in
                        DispatchQueue.main.async {
                            cell.configCellImage(text: "", image: image, alpha: 1)
                        }
                    }
                }
            } else { //未取到資料
                cell.Lable3.text = "載入中.." }
            return cell

        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //點擊
        if collectionView == self.TopcollectionView { //點擊top
            print("點擊\(indexPath.row)")
            self.topnum = indexPath.row
            whichData()
            BotcollectionView.reloadData()
        }
        else { //點擊bottom
            self.waiting.alpha = 1
            self.waiting.startAnimating()
            print("點擊\(indexPath.row + 1)")
            UserDefaults.standard.set(self.topnum, forKey: "topnum")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.performSegue(withIdentifier: "showanimal", sender: self.animaldata[indexPath.row].animal_subid)
            }
        }
    }

    //傳row值給下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TwoViewController
        controller.ID = sender as? String
    }

    //取值
    func animalApiRequest() {
        viewModel.requestAnimalData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            self.animaldata2 = self.viewModel.All
            self.arrayCount = self.animaldata2.count
            print(":pppppppp")
            DispatchQueue.main.async {
                self.BotcollectionView.reloadData()
                self.landing.image = nil
            }
        }, onError: { (Error) in
            print("fuckkkkkkkk:\(Error)")
        }, onCompleted: {
            print("yaaaaaaaaa")
        }, onDisposed: nil).disposed(by: bag)
    }

    //判斷是拿哪個資料
    func whichData() {
        switch self.topnum {
        case 0:
            self.animaldata = self.animaldata2
            self.arrayCount = self.animaldata.count
            break
        case 1:
            self.animaldata = viewModel.cat
            self.arrayCount = self.animaldata.count
            break
        case 2:
            self.animaldata = viewModel.dog
            self.arrayCount = self.animaldata.count
            break
        case 3:
            self.animaldata = viewModel.taipei
            self.arrayCount = self.animaldata.count
            break
        case 4:
            self.animaldata = viewModel.Tainan
            self.arrayCount = self.animaldata.count
            break
        case 5:
            self.animaldata = viewModel.Yunlin
            self.arrayCount = self.animaldata.count
            break
        case 6:
            self.animaldata = viewModel.Kaohsiung
            self.arrayCount = self.animaldata.count
            break
        case 7:
            self.animaldata = viewModel.another
            self.arrayCount = self.animaldata.count
            break
        default:
            self.topnum = 0
            break
        }
    }
}


