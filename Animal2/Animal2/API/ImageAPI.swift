//
//  ImageApi.swift
//  GameAB2
//
//  Created by 王一平 on 2019/8/7.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit

//使用原生API請求方法 和從網路上接api的方向方法不同
class ImageAPI {
    var some : [() -> Void] = []
    
    func GetImage(url : String , some : @escaping ((UIImage)-> Void )){
        if let url = URL(string: url ) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data ,let image = UIImage(data: data){
                    some(image)
                }
                else {
                    print("no")
                }
            }
            task.resume()
        }
    }
}
