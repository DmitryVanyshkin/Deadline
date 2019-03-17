//
//  TaskViewCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 08/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Ячейка задания - тут посложнее уже

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var isCompletedButton: UIButton! // Кнопка, позволяющая поменять состояние товара
    @IBOutlet weak var taskTextBottom: NSLayoutConstraint!  //Констрейнт - этот что-то новое. По сути, фиксирует отступы разных графических элементов
    @IBOutlet weak var taskDate: UILabel!       //Лейбл даты
    @IBOutlet weak var colorTag: UIView!        //Цвет тега, к которому привязано задание
    @IBOutlet weak var taskText: UILabel!       //Текст самого задания
    
    
    var linkedTask = Task()                     //Привязанное задание - уже писал, зачем так делать
    private var isChecked = false               //Флаг, отвечающий за то, сделано ли задание - нужен для отображения галочки
    
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
    
    func checkForValue(){       //Если задание ещё не сделано, то ставим просто окошко, сделано - галочку
        
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
