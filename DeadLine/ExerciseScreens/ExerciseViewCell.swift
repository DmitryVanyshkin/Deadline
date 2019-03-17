//
//  ExerciseViewCell.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 15/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class ExerciseViewCell: UITableViewCell {           //Класс ячейки, используемой в таблице, отображающей расписание

    @IBOutlet weak var timeStartLabel: UILabel!     //Лейблы с текстом времени начала и конца пары
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!  //Название предмета
    @IBOutlet weak var locationLabelName: UILabel!  //Его расположение
    var linkedExercise = Exercise()                 //Кроме того, для удобства написание кода и некоторой инкапсуляции к каждой ячейке привязывается занятие, которое она отображает. Данная вещь необязательна
    
    override func awakeFromNib() {              //Стандартный метод, прописывающий особенности инициализации ячейки. Генерируется автоматически, лучше не трогать, если не хотим уточнить, что нужно ячейке во время инициализации
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {   //Что происходит при выборе (нажатии ячейки)
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func preloadCellInfo(){         //Функция подгрузки данных с привязанного занятия, дабы не прописывать это в классе таблицы
        //По сути, данный метод - лишь вызывание геттеров с различных полей различных классов, а также корректное преобразование даты
        self.timeStartLabel.text = linkedExercise.getDate.getTime()
        let dateForEnd = linkedExercise.getDate.addingTimeInterval(TimeInterval (linkedExercise.getLength))
        //Строчкой выше я делаю что-то неясное. Ха, это вы так думаете, а я лишь решил для простоты в классе занятия хранить время начала и длительности, вместо двух дат
        self.timeEndLabel.text = dateForEnd.getTime()
        exerciseNameLabel.text = linkedExercise.getName
        locationLabelName.text = linkedExercise.getLocation.getStringLocation()
    }
    
}
