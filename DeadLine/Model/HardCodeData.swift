//
//  HardCodeData.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 03/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

//Данные для теста

let userDmitriy = User(email: "davanyushkin@edu.hse.ru", password: "IDmitriy", fullName: Name(firstName: "Дмитрий", fatherName: "Алексеевич", lastName: "Ванюшкин"), educationProgram: EducationProgram(name: "Информатика и вычислительная техника", short: "БИВ"), minor: "Прикладная экономика", group: "БИВ174")


let math = RelatedTopic(short : "матем", color : "FF2D55")
let stat = RelatedTopic(short : "статис", color : "4CD964")
let prob = RelatedTopic(short : "тервер", color : "FF9500")
let electr = RelatedTopic(short : "электр", color : "FFCC00")
let english = RelatedTopic(short : "англ", color : "007AFF")
let life = RelatedTopic(short : "жизнь", color : "ADCC00")

var formatter : DateFormatter{
    let form = DateFormatter()
    form.dateFormat = "dd.mm.yyyy hh:mm"
    
    return form
}

let exercise18March1 = Exercise(exerciseName: "Теория вероятности и мат статистика", dateStart: formatter.date(from: "18.3.2019 9:00")!, lessonType: LessonType.Lecture, location: AuditoryLocation(adress : "Таллинская, 34", auditoryNumber : "410"))
let exercise18March2 = Exercise(exerciseName: "Теория вероятности и мат статистика", dateStart: formatter.date(from: "18.3.2019 10:30")!, lessonType: LessonType.Lecture, location: AuditoryLocation(adress : "Таллинская, 34", auditoryNumber : "410"))

let exercise18March3 = Exercise(exerciseName: "Теория автоматов", dateStart: formatter.date(from: "18.3.2019 12:10")!, lessonType: LessonType.Lecture, location: AuditoryLocation(adress : "Таллинская, 34", auditoryNumber : "504"))


let defaultTagTopics = [math, stat, prob , electr, english, life]

let colorsList = ["FF3B30", "FF2D55", "FF9500", "FFCC00", "4CD964", "5AC8FA", "007AFF" ]

func loadServer(){
    ApplicationData.shared.server.newUser(user: userDmitriy)
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Покушат", date: Date(), relatedTopic: life, taskOwn: userDmitriy, isTime: true))
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Подумат", date: Date(), relatedTopic: stat, taskOwn: userDmitriy, isTime: true))
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Покакат", date: Date(), relatedTopic: electr, taskOwn: userDmitriy, isTime: true))
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Пописат", date: Date(), relatedTopic : english, taskOwn: userDmitriy, isTime: false))
    ApplicationData.shared.server.exerciseSystem.addExerciseForUser(for: userDmitriy, exercise: exercise18March1)
    ApplicationData.shared.server.exerciseSystem.addExerciseForUser(for: userDmitriy, exercise: exercise18March2)
    ApplicationData.shared.server.exerciseSystem.addExerciseForUser(for: userDmitriy, exercise: exercise18March3)
}
