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
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var goldLabel: UILabel!
    var checked = false
    var id: String?
    var indexPath: IndexPath?
    weak var parentController: HomeTableViewController?
    
    override var frame: CGRect {
        //Setting up cells spacing
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame = newFrame.inset(by: UIEdgeInsets(top: 10, left: 18, bottom: 0, right: 18))
            super.frame = frame
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setIndexPath(index: IndexPath) {
        indexPath = index
    }
    func setup(withtask: TaskUI, parentController : HomeTableViewController) {
        self.layer.cornerRadius = 5
        //self.layer.borderColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        //self.layer.borderWidth = 1
        self.parentController = parentController
        taskNameLabel.text = withtask.name
        //taskDescriptionLabel.text = withtask.description
        goldLabel.text = "Gold: " + String(withtask.gold ?? 0)
        //Setting up different date formats for different dates
        let dateFormatter = DateFormatter()
        let thirtyDays = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        if withtask.datetime != nil {
            let date = Date()
            let calendar = Calendar.current
            let dayStartTime = calendar.startOfDay(for: date)
            let endDayTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
            if withtask.datetime! >= thirtyDays  || withtask.datetime! < Date(){
                //Later task  can display current year
                let date = Date()
                let calendar = Calendar.current
                let componentsNow = calendar.dateComponents([.year], from: date)
                let thisYear = componentsNow.year
                let componentsThen = calendar.dateComponents([.year], from: withtask.datetime!)
                let taskYear = componentsThen.year
                if taskYear != thisYear {
                    if withtask.hasTime == true {
                        dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
                    } else {
                        dateFormatter.dateFormat = "dd.MM.YYYY"
                    }
                } else {
                    if withtask.hasTime == true {
                        dateFormatter.dateFormat = "dd.MM HH:mm"
                    } else {
                        dateFormatter.dateFormat = "dd.MM"
                    }
                }
            }else if withtask.datetime! < endDayTime && withtask.datetime! >= dayStartTime {
                //Todays task can only show time
                if withtask.hasTime == true {
                    dateFormatter.dateFormat = "HH:mm"
                }
            }else {
                //Checking if task has time
                if withtask.hasTime == true {
                    dateFormatter.dateFormat = "EEE dd.MM HH:mm"
                } else {
                    dateFormatter.dateFormat = "EEE dd.MM"
                }
            }
            
            //taskDescriptionLabel.textColor = chosenCompanion.shared.companion.darkToneColor
        }
        id = withtask.dbId
        //Clear for when there's no date
        taskTimeLabel.text = ""
        if withtask.datetime != nil {
            taskTimeLabel.text = dateFormatter.string(from: withtask.datetime!)
        }
        //Setting up checkbox
        checked = withtask.done
        if(withtask.done != true) {
            showUndone()
        } else {
            showDone()
        }
        //Choosing image for quest
        switch withtask.imageNum {
        case 0:
            iconImage.image = UIImage(named: "book_icon")
        case 1:
            iconImage.image = UIImage(named: "bow_icon")
        case 2:
            iconImage.image = UIImage(named: "sword_icon")
        case 3:
            iconImage.image = UIImage(named: "gold_icon")
        case 4:
            iconImage.image = UIImage(named: "heart_icon")
        case 5:
            iconImage.image = UIImage(named: "road_sign")
        default:
            iconImage.image = UIImage(named: "book_icon")
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
        checkboxButton.tintColor = #colorLiteral(red: 0, green: 0.6235294118, blue: 0.2196078431, alpha: 1)
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
            
            //Adding and taking gold
            var totalGold = UserDefaults.standard.integer(forKey: "totalGold")
            
            //Alerts about task completion & update total gold
            if tasksDB!.is_done == true {
                AlertView.instance.showAlert(title: chosenCompanion.shared.companion.getSutuationalPhrase(situations.questCompleted.rawValue), isSticky: false)
                totalGold += Int(tasksDB?.gold ?? 0)
                
            } else {
                AlertView.instance.showAlert(title: chosenCompanion.shared.companion.getSutuationalPhrase(situations.questUndone.rawValue), isSticky: false)
                totalGold -= Int(tasksDB?.gold ?? 0)
            }
            UserDefaults.standard.set(totalGold, forKey: "totalGold")
            //Update data in parent controller
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if self.indexPath != nil {
                    //self.parentController?.tableView.deleteRows(at: [self.indexPath!], with: .fade)
                }
                self.parentController?.updateDataInCells()
            }
            
        }
        catch {
            print("error happend")
        }
    }
}
