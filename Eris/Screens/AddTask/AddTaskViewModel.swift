//
//  AddTaskViewModel.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/9/2566 BE.
//

import Foundation
import CoreData
import AudioToolbox

class AddTaskViewModel {
    func addTask(taskName: String, taskDescription: String, timeText: String?, dateText: String?, goldAmount: String?, imageNum: Int?) -> Bool {
        //Basic task creation
        let context = CoreDataService.shared.context()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let taskAdded = Task(context: context)
        taskAdded.title = taskName
        taskAdded.task_description = taskDescription
        taskAdded.rowid = UUID().uuidString
        taskAdded.gold = Int64(goldAmount ?? "0") ?? 0
        taskAdded.image_number = Int64(imageNum ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if timeText == "" {
            //dateFormatter.timeZone = .gmt
            taskAdded.has_time = false
        } else {
            taskAdded.has_time = true
        }
        //Changing date to fit format
        if dateText != "" {
            var date = dateFormatter.date(from: dateText!)
            let timeString = timeText
            let hours: Int?
            let minutes: Int?
            if timeString != "" {
                hours = Int(String(timeString!.prefix(2)))
                minutes = Int(String(timeString!.suffix(2)))
                let toAdd = hours! * 3600 + minutes! * 60
                date = date! + Double(toAdd)
            }
            taskAdded.due_date = date
        }
        do {
            try context.save()
            return true
        } catch {
            print(error)
            return false
        }
    }
}
