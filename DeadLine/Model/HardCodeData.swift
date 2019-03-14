//
//  HardCodeData.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 03/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

let userDmitriy = User(email: "davanyushkin@edu.hse.ru", password: "IDmitriy", fullName: Name(firstName: "Дмитрий", fatherName: "Алексеевич", lastName: "Ванюшкин"), educationProgram: EducationProgram(name: "Информатика и вычислительная техника", short: "БИВ"), minor: "Прикладная экономика", group: "БИВ174")

let defaultTagTopics = [RelatedTopic(short : "матем", color : "FF2D55"), RelatedTopic(short : "статис", color : "4CD964"), RelatedTopic(short : "тервер", color : "FF9500"), RelatedTopic(short : "электр", color : "FFCC00"), RelatedTopic(short : "англ", color : "007AFF")]

let colorsList = ["FF3B30", "FF2D55", "FF9500", "FFCC00", "4CD964", "5AC8FA", "007AFF" ]

func loadServer(){
    ApplicationData.shared.server.newUser(user: userDmitriy)
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Покушат", date: Date(), relatedTopic: RelatedTopic(), taskOwn: userDmitriy, isTime: true))
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Подумат", date: Date(), relatedTopic: RelatedTopic(), taskOwn: userDmitriy, isTime: true))
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Покакат", date: Date(), relatedTopic: RelatedTopic(), taskOwn: userDmitriy, isTime: true))
    ApplicationData.shared.server.taskSystem.addTaskForUser(for: userDmitriy, task: Task(description: "Пописат", date: Date(), relatedTopic: RelatedTopic(), taskOwn: userDmitriy, isTime: false))
}
