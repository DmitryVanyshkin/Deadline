//
//  TaskSystem.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 01/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

class TaskSystem{
    private var allTasks = [String : [Task]]()
    
    func getTaskForUser(for user : User) -> [Task]?{
        return allTasks[user.getEmail]
    }
    
    func getTaskForUser(for user: User, day : Date) -> [Task]?{
        return allTasks[user.getEmail]?.filter({$0.getDate.getDay() == day.getDay() && $0.getDate.getYear() == day.getYear() && $0.getDate.getMonth() == day.getMonth()})
    }
    
    func getTaskForUser(for user: User, topic : RelatedTopic) -> [Task]?{
        return allTasks[user.getEmail]?.filter({$0.getTopic === topic})
    }
    
    
    func addTaskForUser(for user : User, task : Task){
        if (allTasks[user.getEmail] != nil){
            allTasks[user.getEmail]!.append(task)
        }
        else{
            allTasks[user.getEmail] = [task]
        }
    }
    
    
    
    func deleteTaskForUser(for user : User, task : Task){
        guard var relatedTasks = allTasks[user.getEmail] else{
            return
        }
        
        relatedTasks.removeAll(where: {$0.getUniqueId == task.getUniqueId})
        
    }
    
    
}
