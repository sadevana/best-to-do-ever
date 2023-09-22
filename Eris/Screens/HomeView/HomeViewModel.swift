//
//  HomeViewModel.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/9/2566 BE.
//

import Foundation
import CoreData

class HomeViewModel {
    func getTasksDB() -> [TaskUI] {
        //Getting all tasks fro initial setup
        var tasks = [TaskUI]()
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.returnsObjectsAsFaults = false
        let tasksDB = try! CoreDataService().context().fetch(request)
        for taskDBIns in tasksDB {
            tasks.append(TaskUI(taskDB: taskDBIns))
        }
        return tasks
    }
    func sortTasks(tasks: [TaskUI]) -> Array<Array<TaskUI>> {
        var tasksSorted = tasks
        var sectionedTasks = [[TaskUI](), [TaskUI](), [TaskUI](), [TaskUI]()]
        tasksSorted.sort {
            $0.datetime ?? Date() < $1.datetime ?? Date()
        }
        let todayList = tasksSorted.filter{$0.datetime ?? Date() + Double(86400) < Date() + Double(86400) && $0.datetime ?? Date() - 1 > Date()}
        sectionedTasks[0] = todayList
        let laterList = tasksSorted.filter{$0.datetime ?? Date() - 2 >= Date() + Double(86400) }
        sectionedTasks[1] = laterList
        let noDate = tasksSorted.filter{$0.datetime == nil}
        sectionedTasks[2] = noDate
        let expiredList = tasksSorted.filter{$0.datetime ?? Date() - 1 < Date()}
        sectionedTasks[3] = expiredList
        return sectionedTasks
    }
}
