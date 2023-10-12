//
//  EditTaskViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/9/2566 BE.
//

import UIKit

class EditTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var goldTextField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var descriptionWarningLabel: UILabel!
    @IBOutlet weak var taskNameWarningLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    var taskUI: TaskUI?
    var nameText = ""
    var descriptionText = ""
    
    let editTaskModel = EditTaskViewModel()
    
    var goldValue: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        //Getting values from db
        taskNameField.text = taskUI?.name
        descriptionView.text = taskUI?.description
        goldTextField.text = String(taskUI?.gold ?? 0)
        //Setting up datetime
        if taskUI?.datetime != nil {
            let date = taskUI?.datetime
            //Checking if time was set with date
            if taskUI?.hasTime == true {
                let timeFormater = DateFormatter()
                timeFormater.dateFormat = "HH:mm"
                timeFormater.locale = NSLocale(localeIdentifier: "en_GB") as Locale
                timeTextField.text = timeFormater.string(from: date!)
            }
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            dateTextField.text = dateFormater.string(from: date!)
        }
        //Dynamic button title
        if taskUI?.done ?? false {
            completeButton.setTitle("Mark as incomplete", for: .normal)
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
        timeTextField.addTarget(self, action: #selector(timePickerSetDefault), for: UIControl.Event.editingDidBegin)
        timePicker.addTarget(self, action: #selector(timePickerValueChange), for: UIControl.Event.valueChanged)
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.backgroundColor = UIColor.white
        timePicker.preferredDatePickerStyle = .wheels
        timeTextField.inputView = timePicker
        timeTextField.clearButtonMode = .whileEditing
        //Date field
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM YYYY"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: UIControl.Event.valueChanged)
        dateTextField.addTarget(self, action: #selector(datePickerSetDefault), for: UIControl.Event.editingDidBegin)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.backgroundColor = UIColor.white
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        dateTextField.clearButtonMode = .whileEditing
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
        taskNameField.addTarget(self,
                            action: #selector(nameValidation),
                            for: UIControl.Event.editingChanged)
        descriptionView.delegate = self
        timeTextField.delegate = self
        dateTextField.delegate = self
    }
    @objc func timePickerValueChange(sender: UIDatePicker) {
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        timeFormater.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timeTextField.text = timeFormater.string(from: sender.date)
    }
    @objc func timePickerSetDefault(sender: UITextField) {
        if sender.text == "" {
            timeTextField.text = "12:00"
        }
    }
    @objc func datePickerValueChange(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateTextField.text = dateFormater.string(from: sender.date)
    }
    @objc func datePickerSetDefault(sender: UITextField) {
        if sender.text == "" {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            dateTextField.text = dateFormater.string(from: Date())
        }
    }
    @IBAction func updateTapped(_ sender: Any) {
        if taskNameField.text ?? "" != "" {
            if editTaskModel.updateTask(task: taskUI!, name: taskNameField.text ?? "", description: descriptionView.text, gold: goldTextField.text ?? "", date: dateTextField.text ?? "", time: timeTextField.text ?? "") {
                
                self.navigationController?.popToRootViewController(animated: true)
                AlertView.instance.showAlert(title: "✅ Task successfuly updated")
            }
        } else {
            AlertView.instance.showAlert(title: "❌ Please enter task title")
            taskNameField.becomeFirstResponder()
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
    @objc func nameValidation(_ textField: UITextField) {
        //Name maximum lenght validation
        if textField.text?.count ?? 0 > 500 {
            textField.text = nameText
            taskNameWarningLabel.text = "❌ Too long! Please enter less than 500 symbols"
            return
        } else {
            nameText = textField.text ?? ""
            taskNameWarningLabel.text = ""
            return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 8000 {
            textView.text = descriptionText
            descriptionWarningLabel.text = "❌Too long! Please enter less than 8000 symbols"
        } else {
            descriptionText = textView.text
            descriptionWarningLabel.text = ""
        }
    }
    @IBAction func completeButtonTapped(_ sender: Any) {
        //Change title and add or substract gold
        if editTaskModel.toggleCompletion(task: taskUI!) {
            completeButton.setTitle("Mark as complete", for: .normal)
        } else {
            completeButton.setTitle("Mark as incomplete", for: .normal)
        }
        let wasDone = !(taskUI?.done ?? false)
        taskUI?.done = wasDone
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == timeTextField {
            //Checking if valid time is inputed
            do {
                let timeFormat = try Regex("[0-9]{2}:[0-9]{2}")
                let timeMatch  = try timeFormat.wholeMatch(in: string ) != nil
                if timeMatch {
                    return true
                } else {
                    return false
                }
            } catch {
                print("Regex error")
            }
        }
        if textField == dateTextField {
            //Checking if valid date is inputed
            do {
                let timeFormat = try Regex("[0-9]{2}\\.[0-9]{2}\\.[0-9]{4}")
                let timeMatch  = try timeFormat.wholeMatch(in: string ) != nil
                if timeMatch {
                    return true
                } else {
                    return false
                }
            } catch {
                print("Regex error")
            }
        }
        return true
    }
}
