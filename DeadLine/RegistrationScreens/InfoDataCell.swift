//
//  InfoDataCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 05/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit


//Тут всё просто - класс ячейки для предыдущей табоицы - содержить только текстовый лейбл
class InfoDataCell: UITableViewCell {

    @IBOutlet weak var textContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
