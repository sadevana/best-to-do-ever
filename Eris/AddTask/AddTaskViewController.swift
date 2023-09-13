//
//  AddTaskViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 2/9/2566 BE.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {

    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Border for text area
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionView!.layer.borderColor = borderColor.cgColor
        descriptionView!.layer.borderWidth = 0.3
        descriptionView!.layer.cornerRadius = 5.0
        //Setting up date and time fields
        
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "hh:mm:ss"
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timePickerValueChange), for: UIControl.Event.valueChanged)
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.backgroundColor = UIColor.white
        timePicker.preferredDatePickerStyle = .wheels
        timeField.inputView = timePicker
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM YYYY"
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.backgroundColor = UIColor.white
        datePicker.preferredDatePickerStyle = .wheels
        dateField.inputView = datePicker
    }
    
    @objc func timePickerValueChange(sender: UIDatePicker) {
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "hh:mm:ss"
        timeField.text = timeFormater.string(from: sender.date)
    }
    @objc func datePickerValueChange(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM YYYY"
        dateField.text = dateFormater.string(from: sender.date)
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: Any) {
        //Adding new task
        let context = CoreDataService.shared.context()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let taskAdded = Task(context: context)
        taskAdded.title = taskNameField.text
        taskAdded.task_description = descriptionView.text
        print(taskAdded)
        do {
            try context.save()
            //Going back to home view
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
