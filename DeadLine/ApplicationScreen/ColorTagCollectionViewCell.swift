//
//  ColorTagCollectionViewCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 13/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class ColorTagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var blueChooseLine: UIView!
    @IBOutlet weak var tagNameLabel: UILabel!
    
    var relatedTopic = RelatedTopic()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagNameLabel.layer.cornerRadius = 4
        tagNameLabel.layer.masksToBounds = true
        blueChooseLine.layer.cornerRadius = 5
        blueChooseLine.isHidden = true
    }
    
    func setDataForLabel(){
        
        tagNameLabel.text = relatedTopic.relatedTopicShortForm
        tagNameLabel.backgroundColor = hexStringToUIColor(hex: relatedTopic.relatedTopicColor)
        
    }
    
    func changeBlueLine(){
        blueChooseLine.isHidden = blueChooseLine.isHidden ? false : true
    }

}
