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
    func sortTasks(tasks: [TaskUI]) -> [TaskSections] {
        //Setting up tasks for different section
        var tasksSorted = tasks
        var sectionedTasks = [TaskSections]()
        tasksSorted.sort {
            $0.datetime ?? Date() < $1.datetime ?? Date()
        }
        //Getting dates for borders
        let date = Date()
        let calendar = Calendar.current
        let dayStartTime = calendar.startOfDay(for: date)
        let endDayTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        let endOfWeek = Date().endOfWeek!
        let thirtyDays = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        //Expired
        let expiredList = tasksSorted.filter{$0.datetime ?? Date() + 1 < dayStartTime && $0.done != true && $0.datetime != nil}
        if expiredList.count > 0 {
            sectionedTasks.append(TaskSections(tasks: expiredList, sectionName: "Overdue"))
        }
        //Today
        let todayList = tasksSorted.filter{$0.datetime ?? endDayTime < endDayTime && $0.datetime ?? Date() - 1 > dayStartTime && $0.done != true}
        if todayList.count > 0 {
            sectionedTasks.append(TaskSections(tasks: todayList, sectionName: "Today"))
        }
        //This week
        let thisWeekList = tasksSorted.filter{$0.datetime ?? endOfWeek < endOfWeek && $0.datetime ?? endDayTime + 1 >= endDayTime && $0.done != true}
        if thisWeekList.count > 0 {
            sectionedTasks.append(TaskSections(tasks: thisWeekList, sectionName: "This week"))
        }
        //Next 30 days
        let thirtyDaysList = tasksSorted.filter{$0.datetime ?? thirtyDays < thirtyDays && $0.datetime ?? endOfWeek + 1 >= endOfWeek && $0.done != true}
        if thirtyDaysList.count > 0 {
            sectionedTasks.append(TaskSections(tasks: thirtyDaysList, sectionName: "Next 30 days"))
        }
        //Later
        let laterList = tasksSorted.filter{$0.datetime ?? Date() - 2 >= thirtyDays && $0.done != true}
        if laterList.count > 0 {
            sectionedTasks.append(TaskSections(tasks: laterList, sectionName: "Later"))
        }
        //Date = nil
        let noDate = tasksSorted.filter{$0.datetime == nil && $0.done != true}
        if noDate.count > 0 {
            sectionedTasks.append(TaskSections(tasks: noDate, sectionName: "No date"))
        }
        //Completed tasks
        let doneTasks = tasksSorted.filter({ $0.done })
        if doneTasks.count > 0 {
            sectionedTasks.append(TaskSections(tasks: doneTasks, sectionName: "Done"))
        }
        return sectionedTasks
    }
}
