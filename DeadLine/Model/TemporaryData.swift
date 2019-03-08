//
//  TemporaryData.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

enum WhatDisplay : Int{
    case minors = 0
    case groupName
    case groupNumber
}

class ApplicationData{
    static let shared = ApplicationData()
    
    private var currentUser : User?
    
    private var userToAdd : User?
    
    private var whatDisplay = WhatDisplay.minors
    
    private var server = Server()
    
    
    private let programsList = [EducationProgram(name: "Информатика и вычислительная техника", short: "БИВ"), EducationProgram(name: "Инфокоммуникационные технологии и системы связи", short: "БИТ"), EducationProgram(name: "Прикладная математика", short: "БПМ"), EducationProgram(name: "Логистика и управление цепями поставок", short: "БЛГ"), EducationProgram(name: "Компьютерная безопасность", short: "СКБ", programType : ProgramType.specialist), EducationProgram(name: "Программная инженерия", short: "БПИ"), EducationProgram(name: "Прикладная математика и информатика", short: "БПМИ")]
    
    private let groupsList = ["БИВ" : [4, 5, 5, 5]]
    
    let minorsList = ["Прикладная экономика" , "Стартап", "Бизнес - информатика", "Мир глазами физиков", "Психолгия"]
    
    var getData: [String]{
        switch  whatDisplay {
        case .minors:
            return minorsList
        case .groupName:
            var fullForm = [String]()
            for i in programsList{
                fullForm.append(i.name)
            }
            return fullForm
        case .groupNumber:
            guard let chosenSpec = userToAdd?.getSpecialize else {
                return []
            }
            guard let chosenSpecGroup = groupsList[chosenSpec] else{
                return []
            }
            let date = Date()
            let calendar = NSCalendar.current
            let components = calendar.component(.year, from: date)
            
            let curYear = "\(components)"
            let lastTwoNumbers = Int(curYear)! - 2001
            var chosenGroup = [String]()
            var k = 0
            for i in chosenSpecGroup{
                for j in 1...i{
                    chosenGroup.append("\(chosenSpec)\(lastTwoNumbers - k)\(j)")
                }
                k+=1
            }
            return chosenGroup
        }
    }
    
    func createUserToAdd(){
        userToAdd = User()
    }
    
    func getEducationProgramForName(name : String) -> EducationProgram{
        return programsList.filter{$0.name == name}.first!
    }
    
    var getCurrent : User?{
        return currentUser
    }
    
    var getServer : Server{
        return server
    }
    
    var getDisplay : WhatDisplay{
        return whatDisplay
    }
    
    var getUserToAdd : User?{
        return userToAdd
    }
    
    func setDisplay(what : WhatDisplay){
        whatDisplay = what
    }
    
    private init(){
        
    }
    
    
}
