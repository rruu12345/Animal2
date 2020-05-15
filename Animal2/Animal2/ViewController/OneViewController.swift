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

class OneViewController: UIViewController {

    @IBOutlet weak var landingImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    internal var mAnimalData: [AnimalModel]!
    private var animalData: [AnimalModel]!
    private var refreshControl: UIRefreshControl!
    private var arrayCount: Int = 0
    private var topClickNum: Int = 0
    private var bag: DisposeBag! = DisposeBag()
    private var screenFull = UIScreen.main.bounds.size
    private let viewModel: AnimalViewModel = AnimalViewModel()

    deinit {
        bag = nil
    }

    override func viewDidLoad() { // ->1
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AnimalTopCollectionViewCell.nib, forCellWithReuseIdentifier: "AnimalTopCollectionViewCell")
        collectionView.register(OneCell.nib, forCellWithReuseIdentifier: "OneCell")

        tabBarController?.tabBar.isHidden = true

        //下拉更新
        refreshControl = UIRefreshControl()
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(animalApiRequest), for: UIControl.Event.valueChanged)
        animalApiRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        whichData()
        collectionView.reloadData()
    }

    /// 判斷是拿哪個資料
    private func whichData() {
        let dataArray = [animalData, viewModel.cat, viewModel.dog, viewModel.taipei, viewModel.tainan, viewModel.taichung, viewModel.kaohsiung, viewModel.another]
        mAnimalData = dataArray[topClickNum]
        arrayCount = mAnimalData != nil ? mAnimalData.count : 0
    }

    /// 取值
    @objc private func animalApiRequest() {
        viewModel.requestAnimalData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            self.animalData = self.viewModel.allData.value
            self.arrayCount = self.animalData.count
            self.whichData()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.landingImg.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
            }
            self.refreshControl.endRefreshing()
        }, onError: { (Error) in
            print("fuckkkkkkkk:\(Error)")
        }, onCompleted: {
            print("yaaaaaaaaa")
        }, onDisposed: nil).disposed(by: bag)
    }
}

extension OneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return screenFull.height >= 812 ? CGSize(width: screenFull.width, height: 125 / 896 * screenFull.height) : CGSize(width: screenFull.width, height: 125 / 667 * screenFull.height)
        } else {
            return screenFull.height >= 812 ? CGSize(width: 120 / 414 * screenFull.width, height: 200 / 896 * screenFull.height) : CGSize(width: 99 / 375 * screenFull.width, height: 165 / 667 * screenFull.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 0 : 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets(top: 0, left: 60 / 414 * screenFull.width, bottom: 5 / 896 * screenFull.height, right: 60 / 414 * screenFull.width) : UIEdgeInsets(top: 10 / 896 * screenFull.height, left: 15 / 414 * screenFull.width, bottom: 70 / 896 * screenFull.height, right: 15 / 414 * screenFull.width)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //->3
        if section == 0 {
            return 1
        } else {
            return arrayCount != 0 ? arrayCount : 12
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalTopCollectionViewCell", for: indexPath) as! AnimalTopCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneCell", for: indexPath) as! OneCell
            if arrayCount > 12 { //取到資料
                let data = mAnimalData[indexPath.item]
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
        if indexPath.section == 1 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwoViewController") as! TwoViewController
            vc.idStr = self.mAnimalData[indexPath.item].animal_subid
            vc.topClickNum = topClickNum
            vc.mAnimalData = mAnimalData
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension OneViewController: DidClickHandler {
    func didClickHandler(item: Int) {
        topClickNum = item
        whichData()
        collectionView.reloadData()
    }
}
