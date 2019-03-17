//
//  TemporaryData.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation
import UIKit.UIColor

//Временная мера - синглтон, хранящий основные классы приложения - систему заданий и пар, а так же абстрактный сервер и прочий вспомогательный контент

enum WhatDisplay : Int{
    case minors = 0
    case groupName
    case groupNumber
}

// ЗАГУГЛИТЕ И ОПИШИТЕ СИНГЛТОН В ОТЧЕТЕ

class ApplicationData{
    static let shared = ApplicationData()
    
    var currentUser : User?     //пользователь, который в данный момент залогинен в систему - нужно для отображения всей инфы о нем
    
    private var userToAdd : User?       //Пользователь, который регистрируется в данный момент
    
    private var whatDisplay = WhatDisplay.minors
    
    var server = Server()       //Сервер
    
    let dateManager = DateManager() //Вспомогательный класс, для полноценного отображения дат и работы с нимм
    
    //ХАРДКОД - массив образовательных программ
    private let programsList = [EducationProgram(name: "Информатика и вычислительная техника", short: "БИВ"), EducationProgram(name: "Инфокоммуникационные технологии и системы связи", short: "БИТ"), EducationProgram(name: "Прикладная математика", short: "БПМ"), EducationProgram(name: "Логистика и управление цепями поставок", short: "БЛГ"), EducationProgram(name: "Компьютерная безопасность", short: "СКБ", programType : ProgramType.specialist), EducationProgram(name: "Программная инженерия", short: "БПИ"), EducationProgram(name: "Прикладная математика и информатика", short: "БПМИ")]
    
    //Список количества групп на каждом курсе каждой программы
    private let groupsList = ["БИВ" : [4, 5, 5, 5]]
    
    //список майноров
    let minorsList = ["Прикладная экономика" , "Стартап", "Бизнес - информатика", "Мир глазами физиков", "Психолгия"]
    
    //Это для отображения таблиц с выбором майнора/специальности/групп и тд
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
        case .groupNumber:      //Убералгоритм для генерации названий групп, зная количество групп на каждом курсе
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
    
    func createUserToAdd(){     //Обнуление пользователя после регистрации
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
    
    private init(){     //Приватный конструктор - главная фишка синглтона, обеспечивает его едиственность
        
    }
    
    
}

func hexStringToUIColor (hex:String) -> UIColor {       //Алгоритм преобразования hex-кода в цвет
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
}

func rgbToHex(red : CGFloat, green : CGFloat, blue : CGFloat, alpha: CGFloat) -> String{
    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    return color.toHexString()
}
