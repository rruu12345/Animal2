//
//  OneCell.swift
//  Animal
//
//  Created by  on 2019/8/12.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class OneCell: UICollectionViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var kindLable: UILabel!
    @IBOutlet weak var sexLable: UILabel!
    @IBOutlet weak var statusLable: UILabel!

    static var nib: UINib {
        return UINib(nibName: "OneCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configCellWithModelLove(kind: String, sex: String) {
        kindLable.text = "種類：\(kind)"
        sexLable.text = "性別：\(animalString(str: sex))"
    }

    public func configCellImage(text: String, image: UIImage, alpha: CGFloat) {
        statusLable.text = text
        mImageView.image = image
        mImageView.alpha = alpha
    }

    private func animalString(str: String) -> String {
        var out: String
        if str == "M" {
            out = "男生"
        } else if str == "F" {
            out = "女生"
        } else {
            out = "不明"
        }
        return out
    }
}
