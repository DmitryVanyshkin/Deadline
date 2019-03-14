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
    
    
    var linkedTask = Task()
    private var isChecked = false
    
    let constraintWithNoDate = 10
    override func awakeFromNib() {
        super.awakeFromNib()
        checkForValue()
        preload()
        // Initialization code
    }
    
    func preload(){
        colorTag.layer.cornerRadius = 5

    }
    
    func loadData(){
        self.taskText.text = linkedTask.getDescription
        if (linkedTask.getTimeMatter){
            self.taskDate.text = linkedTask.getDate.convertToShowFullForm()
        }
        else{
            self.taskDate.isHidden = true
            self.taskTextBottom.constant =  CGFloat(self.constraintWithNoDate)
        }
        
        colorTag.backgroundColor = hexStringToUIColor(hex: linkedTask.getTopic.relatedTopicColor)
    }
    
    func checkForValue(){
        
        if (linkedTask.getState == .NotCompleted){
             isCompletedButton.setImage(UIImage(named: "notCompleted"), for: .normal)
            //isCompletedButton.imageView?.image = UIImage(named: "notCompleted")
        }
        else{
            isCompletedButton.setImage(UIImage(named: "Completed"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeTaskState(_ sender: UIButton) {
        linkedTask.switchTaskState()
        checkForValue()
        
    }
    
}
