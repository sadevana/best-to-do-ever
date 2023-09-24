//
//  TaskViewCell.swift
//  Eris
//
//  Created by Dmitry Chicherin on 13/9/2566 BE.
//

import UIKit
import CoreData

class TaskViewCell: UITableViewCell {
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    var checked = false
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(withtask: TaskUI) {
        taskNameLabel.text = withtask.name
        taskDescriptionLabel.text = withtask.description
        goldLabel.text = "Gold reward: " + String(withtask.gold ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM HH:mm"
        id = withtask.dbId
        taskTimeLabel.text = dateFormatter.string(from: withtask.datetime ?? Date())
        //Setting up checkbox
        checkboxButton.layer.cornerRadius = 18.0
        checked = withtask.done
        if(withtask.done != true) {
            showUndone()
        } else {
            showDone()
        }
    }
    @IBAction func checkbox(_ sender: UIButton) {
        if checked == false {
            showDone()
        } else {
            showUndone()
        }
        toggleDone()
        checked = !checked
    }
    func showDone() {
        //visual update
        let image2 = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
        checkboxButton.setImage(image2, for: .normal)
        checkboxButton.tintColor = #colorLiteral(red: 0, green: 0.6246852875, blue: 0.2209637165, alpha: 1)
    }
    func showUndone() {
        //visual update
        let image2 = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
        checkboxButton.setImage(image2, for: .normal)
        checkboxButton.tintColor = .systemGray
    }
    func toggleDone() {
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        //request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "rowid = %@", id!)
        let context = CoreDataService().context()
        let tasksDB = try! context.fetch(request).first
        tasksDB!.is_done = !checked
        do {
            try context.save()
        }
        catch {
            print("error happend")
        }
    }
}
