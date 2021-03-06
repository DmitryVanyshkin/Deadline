//
//  ExerciseSystemClass.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 03/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import Foundation

//Класс системы пар - аналогичен системе занятий
class ExerciseSystem{
    private var allExercises = [String : [Exercise]]()
    
    func getExercisesForUser (for user : User) -> [Exercise]?{
        return allExercises[user.getEmail]
    }
    
    func addExerciseForUser(for user : User, exercise : Exercise){
        if (allExercises[user.getEmail] != nil){
            allExercises[user.getEmail]!.append(exercise)
        }
        else{
            allExercises[user.getEmail] = [exercise]
        }
    }
    
    func getExercisesForUser(for user: User, day : Date) -> [Exercise]?{
        return allExercises[user.getEmail]?.filter({$0.getDate.getDay() == day.getDay() && $0.getDate.getYear() == day.getYear() && $0.getDate.getMonth() == day.getMonth()})
    }
    
    
    func deleteTaskForUser(for user : User, exercise : Exercise){
        guard var relatedExercises = allExercises[user.getEmail] else{
            return
        }
        
        relatedExercises.removeAll(where: {$0.getUniqueId == exercise.getUniqueId})
        
    }
    
    
}
