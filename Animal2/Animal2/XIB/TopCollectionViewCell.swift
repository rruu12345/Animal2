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
    
    static var nib : UINib{
        return UINib(nibName: "TopCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topImage.layer.cornerRadius = topImage.frame.height/2
    }
    public func configCellWithModel(top : [String] , i : Int){
        topImage.image = UIImage(named: top[i])
        Lable.text = "\(top[i])"
    }
}

