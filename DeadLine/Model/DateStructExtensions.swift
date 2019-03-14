//
//  DateStructExtensions.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 11/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

extension Date{
    func getDay() -> Int{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d"
        let currDayNumber = Int(formatter.string(from: self))!
        
        return currDayNumber
    }
    func getMonth() -> Int{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "M"
        let currMonthNumber = Int(formatter.string(from: self))!
        
        return currMonthNumber
    }
    
    func getYear() -> Int{
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY"
        let currYearNumber = Int(formatter.string(from: self))!
        
        return currYearNumber
    }
    
    func convertToShowFullForm() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:MM"
        let thatDay = formatter.string(from: self)
        return thatDay
    }
    
    func getTime() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "h:mm"
        let thatTime = formatter.string(from: self)
        print(thatTime)
        return thatTime
    }
    
    func getDateWithNoTime() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM, yyyy"
        let thatDay = formatter.string(from: self)
        return thatDay
    }
    
    mutating func setTime(hours : Int, minutes : Int){
        print(minutes)
        let time = String(format: "%d:%02d", hours, minutes)
        let day = self.getDateWithNoTime()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM, yyyy H:mm"
        let full = "\(day) \(time)"
        self = formatter.date(from: full)!
        print(self)
        
    }
    
    mutating func setDate(from date : Date){
        let time = self.getTime()
        let day = date.getDateWithNoTime()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM, yyyy H:mm"
        let full = "\(day) \(time)"
        self = formatter.date(from: full)!
    }
    
}
