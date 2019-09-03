//
//  AnimalService.swift
//  Animal2
//
//  Created by 王一平 on 2019/8/29.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit
import Moya

//新增api網址
enum AnimalService {
    case getAnimalJson
}

extension AnimalService : TargetType{
    
    //選擇網址
    var baseURL: URL  {
        switch self {
        case .getAnimalJson:
            return URL(string: "http://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL")!
        }
    }
   
    //選擇路徑
    var path: String {
        switch self {
        case .getAnimalJson:
            return ""
        }
    }
    
    //預設是Method 要改
    //api發出網路請求，希望get資料，從伺服器get資料下來
    var method: Moya.Method {
        switch self {
        case .getAnimalJson :
            return .get
        }
    }
    
    //單元測試模擬，在單元測試文件用(?
    var sampleData: Data {
        switch self {
        case .getAnimalJson :
            return Data()
        }
    }
    
    //task = 鑰匙 讓伺服器辨認人，不同人做的事不同
    var task: Task {
        switch self {
        case .getAnimalJson :
            return .requestPlain
        }
    }
    
    //Google headers 網頁的頭 寫給程式看的 會帶上手機資訊（語系，時間等等）
    var headers: [String : String]? {
        switch self {
        case .getAnimalJson :
            return nil
        }
    }
    
    
}
