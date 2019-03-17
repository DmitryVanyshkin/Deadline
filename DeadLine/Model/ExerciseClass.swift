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

//Вспомогательная структура для расположения занятия

struct AuditoryLocation{
    var adress = String()
    var auditoryNumber = String()
    
    init(){
        adress = "Таллинская, 34"
        auditoryNumber = "308"
    }
    
    init(adress : String, auditoryNumber : String){
        self.adress = adress
        self.auditoryNumber = auditoryNumber
    }
    
    func getStringLocation() -> String{
        return "Ауд. \(auditoryNumber) \(adress)"
    }
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
    
    var getName : String{
        return exerciseName
    }
    
    var getDate : Date{
        return dateStart
    }
    
    var getLength : Int{
        return length
    }
    
    var getLocation : AuditoryLocation{
        return location
    }
    
    init(){
        
    }
    
    init(exerciseName : String, dateStart : Date, length : Int = 80*60, lessonType : LessonType = .Lecture, location : AuditoryLocation){
        self.exerciseName = exerciseName
        self.dateStart = dateStart
        self.length = length
        self.lessonType = lessonType
        self.location = location
        
    }
    
}
