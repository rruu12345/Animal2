//
//  AnimalModel.swift
//  Animal2
//
//  Created by  on 2019/8/29.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import ObjectMapper

class AnimalModel: Mappable {

    var animal_subid: String = ""
    var animal_kind: String = ""
    var animal_sex: String = ""
    var animal_bodytype: String = ""
    var animal_colour: String = ""
    var animal_remark: String = ""
    var animal_opendate: String = ""
    var shelter_name: String = ""
    var album_file: String = ""
    var shelter_address: String = ""
    var shelter_tel: String = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        animal_subid <- map["animal_subid"]
        animal_kind <- map["animal_kind"]
        animal_sex <- map["animal_sex"]
        animal_bodytype <- map["animal_bodytype"]
        animal_colour <- map["animal_colour"]
        animal_remark <- map["animal_remark"]
        animal_opendate <- map["animal_opendate"]
        shelter_name <- map["shelter_name"]
        album_file <- map["album_file"]
        shelter_address <- map["shelter_address"]
        shelter_tel <- map["shelter_tel"]
    }
}
