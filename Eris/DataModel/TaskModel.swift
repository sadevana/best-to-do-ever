//
//  TaskModel.swift
//  Eris
//
//  Created by Dmitry Chicherin on 13/9/2566 BE.
//

import Foundation
import CoreData

struct TaskUI {
    var gold: Int64?
    var description: String?
    var name: String?
    var datetime: Date?
    var done: Bool
    var dbId: String?
    
    init(taskDB: Task) {
        self.gold = taskDB.gold
        self.description = taskDB.task_description
        self.name = taskDB.title
        self.datetime = taskDB.due_date
        self.done = taskDB.is_done
        self.dbId = taskDB.rowid
    }
}
