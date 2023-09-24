//
//  AddTaskViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 2/9/2566 BE.
//

import UIKit
import CoreData
import AudioToolbox

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var goldField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    
    var goldValue: String = "0"
    
    let addTaskViewModel = AddTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
        timePicker.date = Calendar.current.date(bySettingHour: 12, minute: 00, second: 0, of: Date())!
        timePicker.addTarget(self, action: #selector(timePickerValueChange), for: UIControl.Event.valueChanged)
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.backgroundColor = UIColor.white
        timePicker.preferredDatePickerStyle = .wheels
        timeField.inputView = timePicker
        //Date field
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM YYYY"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.backgroundColor = UIColor.white
        datePicker.preferredDatePickerStyle = .wheels
        dateField.inputView = datePicker
        //Other fields
        taskNameField.returnKeyType = .continue
        goldField.keyboardType = .numberPad
        goldField.returnKeyType = .done
        //for setting up keyboard actions
        taskNameField.delegate =  self
        goldField.delegate = self
        //Defaults
        goldField.text = "5"
        //Validation
        goldField.addTarget(self,
                            action: #selector(goldValidation),
                            for: UIControl.Event.editingChanged)
    }
    
    @objc func timePickerValueChange(sender: UIDatePicker) {
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        timeFormater.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timeField.text = timeFormater.string(from: sender.date)
    }
    @objc func datePickerValueChange(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateField.text = dateFormater.string(from: sender.date)
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: Any) {
        AddTask()
    }
    func AddTask() {
        //Adding new task
        if addTaskViewModel.addTask(taskName: taskNameField.text ?? "", taskDescription: descriptionView.text, timeText: timeField.text, dateText: dateField.text, goldAmount: goldField.text) {
            self.navigationController?.popViewController(animated: false)
        }
    }

    //Setting up keyboard actions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func goldValidation(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
            goldValue = "0"
            return
        }
        if textField.text?.prefix(1)  == "0" && textField.text!.count > 1 {
            textField.text = String(textField.text!.suffix(textField.text!.count - 1))
            goldValue = textField.text!
            return
        }
        if Int64(textField.text ?? "0")! > 10000000000 {
            textField.text = goldValue
            return
        }
        else {
            goldValue = textField.text ?? "0"
            return
        }
    }
}
