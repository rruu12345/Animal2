//
//  TopCollectionViewCell.swift
//  Animal
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
    public func configCellWithModel(top: [String], i: Int) {
        topImage.image = UIImage(named: top[i])
        areaLable.text = "\(top[i])"
    }

    func topLayer() {
        let screen = UIScreen.main.bounds.size

        if screen.height >= 812 {
            topImage.layer.cornerRadius = topImage.frame.height / 2
            mView.layer.cornerRadius = mView.frame.height / 2
        } else if screen.height <= 568 {
            topImage.layer.cornerRadius = topImage.frame.height / 2.9
            mView.layer.cornerRadius = mView.frame.height / 2.9
        } else {
            topImage.layer.cornerRadius = topImage.frame.height / 2.5
            mView.layer.cornerRadius = mView.frame.height / 2.5
        }
    }
}

