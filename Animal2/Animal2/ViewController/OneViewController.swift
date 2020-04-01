//
//  OneViewController.swift
//  Animal2
//
//  Created by  on 2019/8/29.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class OneViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var landing: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    var refreshControl: UIRefreshControl!
    var bag: DisposeBag! = DisposeBag()
    var mAnimalData: [AnimalModel]!
    var animaldata: [AnimalModel]!
    var mCount: Int!
    var arrayCount: Int!
    var topClickNum: Int!
    var screenFull = UIScreen.main.bounds.size
    let viewModel: AnimalViewModel = AnimalViewModel()

    deinit {
        bag = nil
    }

    override func viewDidLoad() { // ->1
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        self.landing.alpha = 1

        collectionView.register(TopCollectionViewCell.nib, forCellWithReuseIdentifier: "TopCollectionViewCell")
        collectionView.register(OneCell.nib, forCellWithReuseIdentifier: "OneCell")

        //下拉更新
        refreshControl = UIRefreshControl()
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(reload), for: UIControl.Event.valueChanged)
        animalApiRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        whichData()
        collectionView.reloadData()
    }

    //cell 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return screenFull.height >= 812 ? CGSize(width: screenFull.width, height: 150 / 896 * screenFull.height) : CGSize(width: screenFull.width, height: 125 / 667 * screenFull.height)
        } else {
            return screenFull.height >= 812 ? CGSize(width: 120 / 414 * screenFull.width, height: 200 / 896 * screenFull.height) : CGSize(width: 99 / 375 * screenFull.width, height: 165 / 667 * screenFull.height)
        }
    }

    //cell 條目間距 橫向的左右間距，縱向的上下間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 5
    }

    //cell 條目間距 橫向的上下間距，縱向的左右間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 5
    }

    //cell離邊的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets(top: -20, left: 60 / 414 * screenFull.width, bottom: 5 / 896 * screenFull.height, right: 60 / 414 * screenFull.width) : UIEdgeInsets(top: 10 / 896 * screenFull.height, left: 15 / 414 * screenFull.width, bottom: 20 / 896 * screenFull.height, right: 15 / 414 * screenFull.width)
    }

    //兩個section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    //section裡的item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //->3
        if section == 0 {
            return 1
        } else {
            if (self.arrayCount != nil) {
                self.mCount = self.arrayCount
            } else {
                self.mCount = 12
            }
            return self.mCount
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //->4

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
            cell.delegate = self
//            cell.didClickHandler = { [weak self] item in
//                guard let `self` = self else { return }
//                self.topClickNum = item
//                self.whichData()
//                self.collectionView.reloadData()
//            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCell", for: indexPath) as! OneCell
            if self.mCount > 12 { //取到資料
                whichData()
                let data = self.mAnimalData[indexPath.item]
                cell.configCellWithModelLove(kind: data.animal_kind, sex: data.animal_sex)

                if data.album_file == "" { //無照片
                    let image = UIImage(named: "yuki")
                    cell.configCellImage(text: "無照片", image: image!, alpha: 0.5)
                } else { //有照片
                    if let url = URL(string: data.album_file) {
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
            } else { //未取到資料
                cell.statusLable.text = "載入中.." }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //點擊
        if indexPath.section == 0 {

        } else {
            print("點擊\(indexPath.item + 1)")
            UserDefaults.standard.set(self.topClickNum, forKey: "topClickNum")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.performSegue(withIdentifier: "showanimal", sender: self.mAnimalData[indexPath.item].animal_subid)
            }
        }
    }

    //傳row值給下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TwoViewController
        controller.idStr = sender as? String
    }


    //判斷是拿哪個資料
    func whichData() {
        switch self.topClickNum {
        case 0:
            self.mAnimalData = self.animaldata
            self.arrayCount = self.mAnimalData.count
            break
        case 1:
            self.mAnimalData = viewModel.cat
            self.arrayCount = self.mAnimalData.count
            break
        case 2:
            self.mAnimalData = viewModel.dog
            self.arrayCount = self.mAnimalData.count
            break
        case 3:
            self.mAnimalData = viewModel.taipei
            self.arrayCount = self.mAnimalData.count
            break
        case 4:
            self.mAnimalData = viewModel.tainan
            self.arrayCount = self.mAnimalData.count
            break
        case 5:
            self.mAnimalData = viewModel.taichung
            self.arrayCount = self.mAnimalData.count
            break
        case 6:
            self.mAnimalData = viewModel.kaohsiung
            self.arrayCount = self.mAnimalData.count
            break
        case 7:
            self.mAnimalData = viewModel.another
            self.arrayCount = self.mAnimalData.count
            break
        default:
            self.topClickNum = 0
            break
        }
    }

    //取值
    func animalApiRequest() {
        viewModel.requestAnimalData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            self.animaldata = self.viewModel.allData
            self.arrayCount = self.animaldata.count
            print(":pppppppp")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.landing.image = nil
            }
        }, onError: { (Error) in
            print("fuckkkkkkkk:\(Error)")
        }, onCompleted: {
            print("yaaaaaaaaa")
        }, onDisposed: nil).disposed(by: bag)
    }

    @objc func reload() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}


extension OneViewController: DidClickHandler {

    func didClickHandler(item: Int) {
        self.topClickNum = item
        self.whichData()
        self.collectionView.reloadData()
    }
}