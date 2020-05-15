//
//  AnimalViewModel.swift
//  Animal2
//
//  Created by  on 2019/8/29.
//  Copyright © 2019 . All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation

class AnimalViewModel {

    private let animalApi = AnimalAPI()
    internal var allData = BehaviorRelay<[AnimalModel]>(value: [])
    internal var taipei: [AnimalModel] = []
    internal var tainan: [AnimalModel] = []
    internal var taichung: [AnimalModel] = []
    internal var kaohsiung: [AnimalModel] = []
    internal var cat: [AnimalModel] = []
    internal var dog: [AnimalModel] = []
    internal var another: [AnimalModel] = []

    ///請求資料
    func requestAnimalData() -> Observable<Bool> {
        return animalApi.fetchDataAnimal().flatMap { [weak self](model) -> Observable<Bool> in
            guard let `self` = self else { return Observable.just(false) }
            guard model.count > 0 else { return Observable.just(false) }
            self.allData.accept(model)
            for animalObject in model {
                if animalObject.shelter_address.contains("臺北市") || animalObject.shelter_address.contains("新北市") {
                    self.taipei.append(animalObject)
                }
                else if animalObject.shelter_address.contains("臺南市") {
                    self.tainan.append(animalObject)
                }
                else if animalObject.shelter_address.contains("臺中") {
                    self.taichung.append(animalObject)
                }
                else if animalObject.shelter_address.contains("高雄市") {
                    self.kaohsiung.append(animalObject)
                }
                else {
                    self.another.append(animalObject)
                }

                if animalObject.animal_kind.contains("貓") {
                    self.cat.append(animalObject)
                }
                else {
                    self.dog.append(animalObject)
                }
            }
            return Observable.just(true)
        }
    }

    /// 資料英文轉中文
    internal func animalString(string: String) -> String {
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
}
