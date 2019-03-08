//
//  TaskViewCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 08/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var isCompletedButton: UIButton!
    @IBOutlet weak var taskTextBottom: NSLayoutConstraint!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var taskText: UILabel!
    
    let constraintWithNoDate = 10
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
