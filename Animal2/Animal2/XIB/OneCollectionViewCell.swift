//
//  OneCollectionViewCell.swift
//  Animal
//
//  Created by 王一平 on 2019/8/12.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit

class OneCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var AImage: UIImageView!
    @IBOutlet weak var Lable1: UILabel!
    @IBOutlet weak var Lable2: UILabel!
    @IBOutlet weak var Lable3: UILabel!
    @IBOutlet weak var View: UIView!
    
    static var nib : UINib{
        return UINib(nibName: "OneCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configCellWithModel( i : Int ,model : [AnimalModel]){
        Lable1.text = "種類：\(model[i].animal_kind)"
        Lable2.text = "性別：\(animalString(S: model[i].animal_sex))"
    }
    public func configCellWithModelLove( kind : String ,sex : String){
        Lable1.text = "種類：\(kind)"
        Lable2.text = "性別：\(animalString(S:sex))"
    }
    public func configCellImage(text:String , image:UIImage , alpha : Float){
        Lable3.text = "\(text)"
        AImage.image = image
        AImage.alpha = CGFloat(alpha)
    }
    func animalString(S : String) -> String {
        var out : String?
        if S == "M"{out = "男生"}
        else if S == "F"{out = "女生"}
        else{out = S}
        return out!
    }
}
