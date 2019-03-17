//
//  ColorTagCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 13/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Класс ячейки цветного квадратика для создания нового тега. Имеет цвет и галочку

class ColorTagCell: UICollectionViewCell {
    
    @IBOutlet weak var chosenColor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.red
        chosenColor.isHidden = true
    }
    
    func switchState(){
        chosenColor.isHidden = chosenColor.isHidden ? false : true
    }
    
    func setColor(hex : String){
        self.backgroundColor = hexStringToUIColor(hex: hex)
    }
}
