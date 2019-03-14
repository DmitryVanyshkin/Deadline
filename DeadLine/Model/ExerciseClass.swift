//
//  ExerciseClass.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 03/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

enum LessonType : Int           //Тип занятия - влияет на длину(не всегда) и на то, что будет написано в ячейке
{
    case Lecture = 0
    case Seminar
    case PracticalWork
    case Exam
    case Consultation
    case Resubmit
    case Another
}

struct AuditoryLocation{
    var adress = String()
    var auditoryNumber = String()
}

class Exercise{                 //Класс занятия - нужен для отображения
    private var uniqueId = String()
    private var exerciseName = String() //Имя дисциплины
    private var dateStart = Date()      //Дата начала
    private var length = Int()          //Длительность
    private var lessonType = LessonType.Lecture
    private var location = AuditoryLocation()
    
    var getUniqueId : String{
        return uniqueId
    }
    
    var getDay : Date{
        return dateStart
    }
    
}
