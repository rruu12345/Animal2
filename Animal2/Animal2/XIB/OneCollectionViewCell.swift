//
//  OneCollectionViewCell.swift
//  Animal2
//
//  Created by 王一平 on 2019/9/20.
//  Copyright © 2019 王一平. All rights reserved.
//

//import UIKit
//import RxSwift
//import Kingfisher
//
//class OneCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    var bag: DisposeBag! = DisposeBag()
//    var mAnimalData: [AnimalModel]!
//    var animaldata: [AnimalModel]!
//    var mCount: Int!
//    var arrayCount: Int!
//    var screenFull = UIScreen.main.bounds.size
//    let viewModel: AnimalViewModel = AnimalViewModel()
//
//    static var nib: UINib {
//        return UINib(nibName: "OneCollectionViewCell", bundle: Bundle(for: self))
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(OneCell.nib, forCellWithReuseIdentifier: "OneCell")
//        animalApiRequest()
//    }
//
//    //cell 大小
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if screenFull.height >= 812 {
//            return CGSize(width: 120 / 414 * screenFull.width, height: 200 / 896 * screenFull.height)
//        } else {
//            return CGSize(width: 99 / 375 * screenFull.width, height: 165 / 667 * screenFull.height)
//        }
//    }
//
//    //cell 條目間距 橫向的左右間距，縱向的上下間距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//
//    //cell 條目間距 橫向的上下間距，縱向的左右間距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5
//    }
//
//    //cell離邊的距離
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        if screenFull.height >= 812 {
//            return UIEdgeInsets(top: 10 / 896 * screenFull.height, left: 15 / 896 * screenFull.width, bottom: 20 / 896 * screenFull.height, right: 15 / 896 * screenFull.width)
//        } else {
//            return UIEdgeInsets(top: 10 / 896 * screenFull.height, left: 15 / 896 * screenFull.width, bottom: 20 / 896 * screenFull.height, right: 15 / 896 * screenFull.width)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if (self.arrayCount != nil) {
//            self.mCount = self.arrayCount
//        } else {
//            self.mCount = 12
//        }
//        return self.mCount
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCell", for: indexPath) as! OneCell
//        if self.mCount > 12 { //取到資料
//            let controller = OneViewController()
//            controller.whichData()
//            let data = self.mAnimalData[indexPath.item]
//            cell.configCellWithModelLove(kind: data.animal_kind, sex: data.animal_sex)
//
//            if data.album_file == "" { //無照片
//                let image = UIImage(named: "yuki")
//                cell.configCellImage(text: "無照片", image: image!, alpha: 0.5)
//            } else { //有照片
//                if let url = URL(string: data.album_file) {
//                    DispatchQueue.main.async {
//                        UIImageView().kf.setImage(with: url, placeholder: UIImage(named: "yuki"), options: nil, progressBlock: nil) { (result) in
//                            switch result {
//                            case .success(let success):
//                                cell.configCellImage(text: "", image: success.image, alpha: 1)
//                            case .failure(_):
//                                break
//                            }
//                        }
//                    }
//                }
//            }
//        } else { //未取到資料
//            cell.Lable3.text = "載入中.." }
//        return cell
//    }
//
//    //取值
//    func animalApiRequest() {
//        viewModel.requestAnimalData().subscribe(onNext: { [weak self] (result) in
//            guard let `self` = self else { return }
//            self.animaldata = self.viewModel.All
//            self.arrayCount = self.animaldata.count
//            print(":pppppppp")
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//                //self.landing.image = nil
//            }
//            }, onError: { (Error) in
//                print("fuckkkkkkkk:\(Error)")
//        }, onCompleted: {
//            print("yaaaaaaaaa")
//        }, onDisposed: nil).disposed(by: bag)
//    }
//}
