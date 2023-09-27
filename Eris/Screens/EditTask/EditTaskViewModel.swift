//
//  EditTaskViewModel.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/9/2566 BE.
//

import Foundation
import CoreData

class EditTaskViewModel {
    
    func deleteTask(task: TaskUI) -> Bool {
        //Task deletion
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        //request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "rowid = %@", task.dbId!)
        let context = CoreDataService().context()
        let tasksDB = try! context.fetch(request).first
        if (tasksDB != nil) {
            context.delete(tasksDB!)
        }
        do {
            try context.save()
            return true
        }
        catch {
            print("error happend")
            return false
        }
    }
    
    func updateTask(task: TaskUI, name: String, description: String, gold: String, date: String, time: String) -> Bool {
        //Task editing
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        //request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "rowid = %@", task.dbId!)
        let context = CoreDataService().context()
        let tasksDB = try! context.fetch(request).first
        if (tasksDB != nil) {
            tasksDB!.title = name
            tasksDB!.task_description = description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if time == "" {
                dateFormatter.timeZone = .gmt
            }
            //Changing date to fit format
            if date != "" {
                var dateDate = dateFormatter.date(from: date)
                let timeString = time
                let hours: Int?
                let minutes: Int?
                if time != "" {
                    hours = Int(String(time.prefix(2)))
                    minutes = Int(String(time.suffix(2)))
                    let toAdd = hours! * 3600 + minutes! * 60
                    dateDate = dateDate! + Double(toAdd)
                }
                tasksDB!.due_date = dateDate
            }
        }
        do {
            try context.save()
            return true
        }
        catch {
            print("error happend")
            return false
        }
    }
    
}