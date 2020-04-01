//
//  AnimalAPI.swift
//  Animal2
//
//  Created by on 2019/8/29.
//  Copyright © 201. All rights reserved.
//

import UIKit
//透過此來得到功能MoyaProvider
import Moya
import Moya_ObjectMapper
import RxSwift

//protocol : class 一定要class才能使用weak
//利用protocol規範方法 誰掛上此protocol誰就要實作他定義的方法。
protocol AnimalProtocol: class {
    func fetchData(AnimalModel: [AnimalModel])
}

class AnimalAPI {
    //Queue序列
    //前景
    let mainQueue = MainScheduler.instance
    //背景
    let backQueue = SerialDispatchQueueScheduler.init(qos: .background)
    //<資料來源>() 方法的名字(資料來源)() 實例化init
    let provider = MoyaProvider<AnimalService>()
    //創一個變數來遵從AnimalProtocol
    weak var delegate: AnimalProtocol?

//    func requeset() {
//        //供應商發出請求向 getAnimalJson 拿資料回來
//        //閉包前加上weak self 防止循環引計數(realtain cycle)
//        //返還的結果result
//        provider.request(.getAnimalJson) { [weak self] (result) in
//            //透過mapArray把抓下來的資料套用在定義好的資料模組（AnimalModel）   123
//            guard let model = try! result.value?.mapArray(AnimalModel.self) else { return }
//            guard let `self` = self else { return }
//            //model套上protocol
//            //透過定義好的delegate變數使用fetchData方法拿到解析完的資料
//            self.delegate?.fetchData(AnimalModel: model)
//            print("okkkkkkkkkkkkkkkkk")
//        }
//    }
    
    /// 可被觀察的對象
    func fetchDataAnimal() -> Observable<[AnimalModel]> {
        //供應商使用rx請求方法請getAnimalJson變成可觀察對象，之後解析資料放到AnimalModel，訂閱事件放在背景，觀察事件放在前景?
        return provider.rx.request(.getAnimalJson).asObservable().mapArray(AnimalModel.self).subscribeOn(backQueue).observeOn(mainQueue)
    }
}
