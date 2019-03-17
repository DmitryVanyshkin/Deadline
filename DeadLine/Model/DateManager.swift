//
//  DateManager.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 09/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation
//Вспомогательный класс для преобразования и отображения даты
class DateManager{
    private let monthsDay = [1 : 31, 2 : 28, 3 : 31, 4 : 30, 5 : 31, 6 : 30, 7 : 31, 8 : 31, 9 : 30, 10 : 31, 11 : 30, 12 : 31]     //Словарь вида номер месяца - количество дней
    
    func getAmountForSlider() -> [Int]{ //Метод ддя получения количества дней в каждом месяце
        var daysInMonth = [Int]()
        
        let today = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "M"
        let monthNumber = Int(formatter.string(from: today))!
        
        switch monthNumber {
        case 1:
            daysInMonth = [monthsDay[11]!, monthsDay[11]! + monthsDay[12]!, monthsDay[11]! + monthsDay[12]! + monthsDay[1]!, monthsDay[11]! + monthsDay[12]! + monthsDay[1]! + monthsDay[2]!,monthsDay[11]! + monthsDay[12]! + monthsDay[1]! + monthsDay[2]! + monthsDay[3]!]
            
        case 2:
            daysInMonth = [monthsDay[12]!, monthsDay[12]! + monthsDay[1]!, monthsDay[12]! + monthsDay[1]! + monthsDay[2]!, monthsDay[12]! + monthsDay[1]! + monthsDay[2]! + monthsDay[3]!,monthsDay[12]! + monthsDay[1]! + monthsDay[2]! + monthsDay[3]! + monthsDay[4]!]
        case 11:
            daysInMonth = [monthsDay[9]!, monthsDay[9]! + monthsDay[10]!, monthsDay[9]! + monthsDay[10]! + monthsDay[11]!, monthsDay[9]! + monthsDay[10]! + monthsDay[11]! + monthsDay[12]!,monthsDay[9]! + monthsDay[10]! + monthsDay[11]! + monthsDay[12]! + monthsDay[1]!]
        case 12:
            daysInMonth = [monthsDay[10]!, monthsDay[10]! + monthsDay[11]!, monthsDay[10]! + monthsDay[11]! + monthsDay[12]!, monthsDay[10]! + monthsDay[11]! + monthsDay[12]! + monthsDay[1]!,monthsDay[10]! + monthsDay[11]! + monthsDay[12]! + monthsDay[1]! + monthsDay[2]!]
        default:
            daysInMonth = [monthsDay[monthNumber - 2]!, monthsDay[monthNumber - 2]! + monthsDay[monthNumber - 1]!, monthsDay[monthNumber - 2]! + monthsDay[monthNumber - 1]! + monthsDay[monthNumber]!, monthsDay[monthNumber - 2]! + monthsDay[monthNumber - 1]! + monthsDay[monthNumber]! + monthsDay[monthNumber + 1]!,monthsDay[monthNumber - 2]! + monthsDay[monthNumber - 1]! + monthsDay[monthNumber]! + monthsDay[monthNumber + 1]! + monthsDay[monthNumber + 2]!]
        }
        
        return daysInMonth
    }
    
    func countDayNumber(number : Int, arrayMonthRanges : [Int]) -> Int{     //Преобразование номера дня, который может превышать общее число дней месяца в нормальный день
        
        let monthCount = arrayMonthRanges.last(where: {number > $0}) ?? 0
        return number - monthCount
    }
    
    func convertToday(arrayMonthRanges : [Int], today : Date = Date()) -> Int{  //Похожее дело
        var number = Int()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d"
        let dayNumber = Int(formatter.string(from: today))!
        
        number = arrayMonthRanges[1] + dayNumber
        return number
    }
    
    func countNumberToDay(number : Int) -> Date{        //Преобразование числа в дату
        let today = Date()
        let formatter = DateFormatter()
        var yearChange = 0
        
        formatter.dateFormat = "M"
        let currMonthNumber = Int(formatter.string(from: today))!
        
        formatter.dateFormat = "YYYY"
        let currYear = Int(formatter.string(from: today))
        
        let daysArray = getAmountForSlider()
        var monthNumberInArray = 0
        
        while (number > daysArray[monthNumberInArray]){
            monthNumberInArray+=1
            if (monthNumberInArray == 4){
                break
            }
        }
        
        monthNumberInArray-=2
        
        var monthNumber = currMonthNumber + monthNumberInArray
        
        if monthNumber < 0{
            monthNumber+=12
            yearChange-=1
        }
        else if (monthNumber > 12){
            monthNumber-=12
            yearChange+=1
        }
        
        let monthCount = daysArray.last(where: {number > $0}) ?? 0
        let dayNumber = number - monthCount
        
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.date(from: "\(dayNumber).\(monthNumber).\(currYear! - yearChange)")!

        return date
    }
    
    
    
}
