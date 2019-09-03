//
//  AnimalModel.swift
//  Animal2
//
//  Created by 王一平 on 2019/8/29.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit
import ObjectMapper


class AnimalModel: Mappable {
    
    //var animal_id : Int
    var animal_subid : String = ""
    //var animal_area_pkid : Int
    //var animal_shelter_pkid : Int
    //var animal_place : String
    var animal_kind : String = ""
    var animal_sex : String = ""
    var animal_bodytype : String = ""
    var animal_colour : String = ""
    //var animal_age : String
    //var animal_sterilization : String
    //var animal_bacterin : String
    //var animal_foundplace : String
    //var animal_title : String?
    //var animal_status : String
    var animal_remark : String = ""
    //var animal_caption : String?
    var animal_opendate : String = ""
    //var animal_closeddate : String
    //var animal_update : String
    //var animal_createtime : String
    var shelter_name : String = ""
    var album_file : String = ""
    //var album_update : String?
    //var cDate : String
    var shelter_address : String = ""
    var shelter_tel : String = ""
    
    //在對象序列化前驗證JSON合法性?
    required init?(map: Map) {

    }
    
    //Mappable解析json用
    //required init 不確定功能？
    //mapping 把定義好的變數透過映射的方式給值，  自定義變數 <- map["參數key"]
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
