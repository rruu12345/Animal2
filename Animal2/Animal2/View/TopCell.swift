//
//  TopCell.swift
//  Animal2
//
//  Created by on 2019/8/12.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class TopCell: UICollectionViewCell {

    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var areaLable: UILabel!
    @IBOutlet weak var mView: UIView!

    static var nib: UINib {
        return UINib(nibName: "TopCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        topLayer()
    }
    public func configCellWithModel(imageStr: String) {
        topImage.image = UIImage(named: imageStr)
        areaLable.text = imageStr
    }

    func topLayer() {
        let screen = UIScreen.main.bounds.size
        var radius: CGFloat
        if screen.height >= 812 {
            radius = 2.3
        } else if screen.height <= 568 {
            radius = 2.9
        } else {
            radius = 2.5
        }
        topImage.layer.cornerRadius = topImage.frame.height / radius
        mView.layer.cornerRadius = mView.frame.height / radius
    }
}
