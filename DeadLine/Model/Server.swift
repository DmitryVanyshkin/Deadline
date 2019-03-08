//
//  Server.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 04/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

class Server{
    private var users = [User]()
    
    let taskSystem = TaskSystem()
    let exerciseSystem = ExerciseSystem()
    
    func newUser(user : User){
        users.append(user)
    }
}
