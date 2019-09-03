//
//  AnimalViewModel.swift
//  Animal2
//
//  Created by 王一平 on 2019/8/29.
//  Copyright © 2019 王一平. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation

class AnimalViewModel {
    
    let AnimalApi = AnimalAPI()
    var num = 0
    var All : [AnimalModel] = []
    var taipei:[AnimalModel] = []
    var Tainan:[AnimalModel] = []
    var Yunlin:[AnimalModel] = []
    var Kaohsiung:[AnimalModel] = []
    var cat:[AnimalModel] = []
    var dog:[AnimalModel] = []
    var another:[AnimalModel] = []
    
    //創建RxSwift的型態宣告 並給予初始值
    var animal_Subid = BehaviorRelay<String>(value: "")
    var animal_Kind = BehaviorRelay<String>(value: "")
    var animal_Sex = BehaviorRelay<String>(value: "")
    var animal_Bodytype = BehaviorRelay<String>(value: "")
    var animal_Colour = BehaviorRelay<String>(value: "")
    var animal_Remark = BehaviorRelay<String>(value: "")
    var animal_Opendate = BehaviorRelay<String>(value: "")
    var shelter_Name = BehaviorRelay<String>(value: "")
    var album_Filed = BehaviorRelay<String>(value: "")
    var shelter_Address = BehaviorRelay<String>(value: "")
    var shelter_Tel = BehaviorRelay<String>(value: "")
    
    //執行請求資料的方法
    func requestAnimalData() -> Observable<Bool> {
        //把AnimalApi的方法fetchDataAnimal的結果物件轉變(flatMap)為可觀察對象，最後回傳訂閱(資料是否有拿到)成功與否
        return AnimalApi.fetchDataAnimal().flatMap{ [weak self](model) -> Observable<Bool> in
            //Observable.just() .just只是一個bool的物件
            guard let `self` = self else{return Observable.just(false)}
            guard model.count > 0 else{return Observable.just(false)}
            self.All = model
            self.loadDataWithIndexPlus(i: self.num)
            for animalObject in model {
                if animalObject.shelter_address.contains("臺北市") || animalObject.shelter_address.contains("新北市") {
                    self.taipei.append(animalObject)
                }
                else if animalObject.shelter_address.contains("臺南市"){
                    self.Tainan.append(animalObject)
                }
                else if animalObject.shelter_address.contains("雲林"){
                    self.Yunlin.append(animalObject)
                }
                else if animalObject.shelter_address.contains("高雄市"){
                    self.Kaohsiung.append(animalObject)
                }
                else{
                    self.another.append(animalObject)
                }
                
                if animalObject.animal_kind.contains("貓"){
                    self.cat.append(animalObject)
                }
                else{
                    self.dog.append(animalObject)
                }
            }
            return Observable.just(true)
        }
    }
    
    func loadDataWithIndexPlus(i:Int) {
        //將AnimalModel的某筆資料存到model
        let model = All[num]
        //把RxSwift的變數綁定(accept)某個model的某屬性
        animal_Subid.accept(model.animal_subid)
        animal_Kind.accept(model.animal_kind)
        animal_Sex.accept(model.animal_sex)
        animal_Bodytype.accept(model.animal_bodytype)
        animal_Colour.accept(model.animal_colour)
        animal_Remark.accept(model.animal_remark)
        animal_Opendate.accept(model.animal_opendate)
        shelter_Name.accept(model.shelter_name)
        album_Filed.accept(model.album_file)
        shelter_Address.accept(model.shelter_address)
        shelter_Tel.accept(model.shelter_tel)
        }
}

//extension AnimalViewModel : AnimalProtocol{
//    func fetchData(AnimalModel: [AnimalModel]) {
//        self.AnimalModel = AnimalModel
//        getModel(self.AnimalModel[num])
//    }
//}
