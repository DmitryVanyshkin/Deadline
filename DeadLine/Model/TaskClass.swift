//
//  TaskSystem.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 01/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

enum TaskState : Int{              //Состояние товара - пока что только два, но в перспективе можно будет расширить
    case NotCompleted = 0
    case Completed
}

struct RelatedTopic{                       //Данная структура описывает тему, с которой связано то или иное задание
    var relatedTopicName = String()         //Полное имя - для хранения
    var relatedTopicShortForm = String()    //Сокращенная форма - отображается на экране
    var relatedTopicColor = String()        //Цвет - для отображения на экране
}

class Task{                                 //Класс задания - основной элемент для отображения в TODO
    private var uniqueId = String()
    private var taskDescription = String()  //Название задания
    private var taskDate = Date()           //Его дата
    private var relatedTopic = RelatedTopic()   //С какой темой связано
    private var taskState = TaskState.NotCompleted  //Состояние задания
    private var taskOwner : User
    
    var getDescription : String{
        return taskDescription
    }
    
    var getDate : Date{
        return taskDate
    }
    
    var getTopic : RelatedTopic{
        return relatedTopic
    }
    
    var getState : TaskState{
        return taskState
    }
    
    var getUniqueId : String{
        return uniqueId
    }
    
    init(description : String, date : Date, relatedTopic : RelatedTopic, taskOwn : User) {
        self.taskDescription = description
        self.taskDate = date
        self.relatedTopic = relatedTopic
        self.taskOwner = taskOwn
    }
    
    func completeTask(){
        self.taskState = .Completed
    }
    
    func setDescription(description : String){
        self.taskDescription = description
    }
    
    func setDate(date : Date){
        self.taskDate = date
    }
    
    func setTopic(topic : RelatedTopic){
        self.relatedTopic = topic
    }
}
