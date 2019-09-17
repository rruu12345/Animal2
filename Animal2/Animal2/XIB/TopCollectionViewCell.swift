//
//  TopCollectionViewCell.swift
//  Animal
//
//  Created by 王一平 on 2019/8/12.
//  Copyright © 2019 王一平. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var Lable: UILabel!
    
    @IBOutlet weak var View: UIView!
    static var nib : UINib{
        return UINib(nibName: "TopCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screen = UIScreen.main.bounds.size

        if screen.height >= 812{
            topImage.layer.cornerRadius = topImage.frame.height/2
            View.layer.cornerRadius = View.frame.height/2
        } else if screen.height <= 568 {
            topImage.layer.cornerRadius = topImage.frame.height/2.9
            View.layer.cornerRadius = View.frame.height/2.9
        } else{
            topImage.layer.cornerRadius = topImage.frame.height/2.5
            View.layer.cornerRadius = View.frame.height/2.5
        }
    }
    public func configCellWithModel(top : [String] , i : Int){
        topImage.image = UIImage(named: top[i])
        Lable.text = "\(top[i])"
    }
}

