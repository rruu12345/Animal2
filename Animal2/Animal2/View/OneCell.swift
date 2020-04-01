//
//  OneCollectionViewCell.swift
//  Animal
//
//  Created by  on 2019/8/12.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class OneCell: UICollectionViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var kindlable: UILabel!
    @IBOutlet weak var sexLable: UILabel!
    @IBOutlet weak var statusLable: UILabel!

    static var nib: UINib {
        return UINib(nibName: "OneCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    public func configCellWithModelLove(kind: String, sex: String) {
        kindlable.text = "種類：\(kind)"
        sexLable.text = "性別：\(animalString(Str: sex))"
    }
    public func configCellImage(text: String, image: UIImage, alpha: Float) {
        statusLable.text = "\(text)"
        mImageView.image = image
        mImageView.alpha = CGFloat(alpha)
    }
    func animalString(Str: String) -> String {
        var out: String?
        if Str == "M" {
            out = "男生"
        } else if Str == "F" {
            out = "女生"
        } else {
            out = "不明"
        }
        return out!
    }
}
