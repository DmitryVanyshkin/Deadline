//
//  UserClass.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 01/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation
class User {                                                //Класс пользователя - основной юнит нашего приложения
    private var email = String()
    private var password = String()
    private var fullName = Name()
    private var educationProgram = EducationProgram()
    private var minor : String? = nil
    private var group = String()
    
    var getEmail : String{
        return email
    }
    
    var getPassword : String{
        return password
    }
    
    var getFirstName : String{
        return fullName.firstName
    }
    
    var getLastName : String{
        return fullName.firstName
    }
    
    var getMiddleName : String{
        return fullName.fatherName
    }
    
    var getSpecializeFull : String{
        return educationProgram.name
    }
    
    var countGrade : Int?{
        var gr = Int()
        if (group.isEmpty){
            return nil
        }
        let yearSubmit = Int(String(group[group.index(before: group.index(before: group.endIndex))]))
        guard let _ = yearSubmit else{
            return nil
        }
        gr = 9 - yearSubmit!
        return gr
    }
    
    var getSpecialize : String{
        return educationProgram.shortForm
    }
    
    var getGroup : String{
        return group
    }
    
    var getMinor : String{
        return minor ?? ""
    }
    
    func setFirstName(name : String){
        fullName.firstName = name
    }
    
    func setLastName(name : String){
        fullName.lastName = name
    }
    
    func setFatherName(name : String){
        fullName.fatherName = name
    }
    
    func setPassword(password : String){
        self.password = password
    }
    
    func setEmail(email : String){
        self.email = email
    }
    
    func setMinor(minor : String){
        self.minor = minor
    }
    
    func setGroup(group : String){
        self.group = group
    }
    
    func setProgramName(name : String, shortForm : String){
        educationProgram.name = name
        educationProgram.shortForm = shortForm
    }
    
    func setProgramName(educationProgram : EducationProgram){
        self.educationProgram = educationProgram
    }
    
    
}

struct Name{
    var firstName = String()
    var fatherName = String()
    var lastName = String()
}

struct EducationProgram{
    var name = String()
    var shortForm = String()
    var programType = ProgramType.bachelor
    
    init(name : String, short : String, programType : ProgramType = ProgramType.bachelor){
        self.name = name
        self.shortForm = short
        self.programType = programType
    }
    
    init(){
        
    }
}

enum ProgramType : Int{
    case bachelor = 0
    case specialist
    case master
}
