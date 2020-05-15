//
//  AnimalAPI.swift
//  Animal2
//
//  Created by on 2019/8/29.
//  Copyright © 201. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper
import RxSwift

class AnimalAPI {
    internal let mainQueue = MainScheduler.instance
    internal let backQueue = SerialDispatchQueueScheduler.init(qos: .background)
    private let provider = MoyaProvider<AnimalService>()
    
    /// 請求animalAPi
    ///
    /// - Returns: 回傳AnimalModel物件
    func fetchDataAnimal() -> Observable<[AnimalModel]> {
        return provider.rx.request(.getAnimalJson).asObservable().mapArray(AnimalModel.self).subscribeOn(backQueue).observeOn(mainQueue)
    }
}
