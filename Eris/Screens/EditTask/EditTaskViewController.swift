//
//  EditTaskViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/9/2566 BE.
//

import UIKit

class EditTaskViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var goldTextField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    var taskUI: TaskUI?
    
    let editTaskModel = EditTaskViewModel()
    
    var goldValue: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        //Getting values from db
        taskNameField.text = taskUI?.name
        descriptionView.text = taskUI?.description
        //Setting up datetime
        if taskUI?.datetime != nil {
            let date = taskUI?.datetime
            let timeFormater = DateFormatter()
            timeFormater.dateFormat = "HH:mm"
            timeFormater.locale = NSLocale(localeIdentifier: "en_GB") as Locale
            timeTextField.text = timeFormater.string(from: date!)
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            dateTextField.text = dateFormater.string(from: date!)
        }
        
        
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
        timeTextField.inputView = timePicker
        //Date field
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM YYYY"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.backgroundColor = UIColor.white
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        //Other fields
        taskNameField.returnKeyType = .continue
        goldTextField.keyboardType = .numberPad
        goldTextField.returnKeyType = .done
        //for setting up keyboard actions
        taskNameField.delegate =  self
        goldTextField.delegate = self
        //Validation
        goldTextField.addTarget(self,
                            action: #selector(goldValidation),
                            for: UIControl.Event.editingChanged)
    }
    @objc func timePickerValueChange(sender: UIDatePicker) {
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        timeFormater.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timeTextField.text = timeFormater.string(from: sender.date)
    }
    @objc func datePickerValueChange(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormater.string(from: sender.date)
    }
    @IBAction func updateTapped(_ sender: Any) {
        if editTaskModel.updateTask(task: taskUI!, name: taskNameField.text ?? "", description: descriptionView.text, gold: goldTextField.text ?? "", date: dateTextField.text ?? "", time: timeTextField.text ?? "") {
        
            self.navigationController?.popToRootViewController(animated: true)
            AlertView.instance.showAlert(title: "✅ Task successfuly updated")
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if editTaskModel.deleteTask(task: taskUI!){
            self.navigationController?.popViewController(animated: true)
            AlertView.instance.showAlert(title: "❌ Task deleted successfuly")
        }
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
