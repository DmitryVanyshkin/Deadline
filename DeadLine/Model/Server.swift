//
//  Server.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

//Класс сервера - хранит всех пользователей и прочую инфу

class Server{
    private var users = [User]()
    
    let taskSystem = TaskSystem()
    let exerciseSystem = ExerciseSystem()
    
    func newUser(user : User){
        users.append(user)
    }
    
    func authorizeUser(email : String, password : String) -> User?{     //Проверка на то, есть ли такой пользователь в системе
        return users.first(where: {$0.getEmail == email && $0.getPassword == password})
    }
}
