//
//  AnimalService.swift
//  Animal2
//
//  Created by  on 2019/8/29.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import Moya

enum AnimalService {
    case getAnimalJson
}

extension AnimalService: TargetType {

    var baseURL: URL {
        switch self {
        case .getAnimalJson:
            return URL(string: "https://data.coa.gov.tw/Service/OpenData/TransService.aspx?UnitId=QcbUEzN6E6DL")!
        }
    }

    var path: String {
        switch self {
        case .getAnimalJson:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAnimalJson:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .getAnimalJson:
            return Data()
        }
    }

    var task: Task {
        switch self {
        case .getAnimalJson:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .getAnimalJson:
            return nil
        }
    }
}
