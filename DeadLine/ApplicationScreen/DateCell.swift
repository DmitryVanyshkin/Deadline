//
//  DateCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 09/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {

    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var blueChooseLine: UIView!
    @IBOutlet weak var dateNumberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        blueChooseLine.layer.cornerRadius = 5
        
    }

}
