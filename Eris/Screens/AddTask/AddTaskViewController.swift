//
//  AddTaskViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 2/9/2566 BE.
//

import UIKit
import CoreData
import AudioToolbox

class AddTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var goldField: UITextField!
    @IBOutlet weak var taskNameWarningLabel: UILabel!
    @IBOutlet weak var descriptionWarningLabel: UILabel!
    @IBOutlet weak var iconPicker: UISegmentedControl!
    @IBOutlet weak var descriptionView: UITextView!
    
    //Default value for gold
    var goldValue: String = "5"
    var nameText = ""
    var descriptionText = ""
    
    let addTaskViewModel = AddTaskViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        //Border for text area
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionView!.layer.borderColor = borderColor.cgColor
        descriptionView!.layer.borderWidth = 0.3
        descriptionView!.layer.cornerRadius = 5.0
        //Icon Picker style
        iconPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        iconPicker.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        iconPicker.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        iconPicker.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        //Setting up date and time fields
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "hh:mm:ss"
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.date = Calendar.current.date(bySettingHour: 12, minute: 00, second: 0, of: Date())!
        timePicker.addTarget(self, action: #selector(timePickerValueChange), for: UIControl.Event.valueChanged)
        timeField.addTarget(self, action: #selector(timePickerSetDefault), for: UIControl.Event.editingDidBegin)
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.frame.size = CGSize(width: 0, height: 300)
        timePicker.backgroundColor = UIColor.white
        timePicker.preferredDatePickerStyle = .wheels
        timeField.clearButtonMode = .whileEditing
        timeField.inputView = timePicker
        //Date field
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM YYYY"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChange), for: UIControl.Event.valueChanged)
        dateField.addTarget(self, action: #selector(datePickerSetDefault), for: UIControl.Event.editingDidBegin)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.backgroundColor = UIColor.white
        datePicker.preferredDatePickerStyle = .wheels
        dateField.clearButtonMode = .whileEditing
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
        taskNameField.addTarget(self,
                            action: #selector(nameValidation),
                            for: UIControl.Event.editingChanged)
        descriptionView.delegate = self
        dateField.delegate = self
        timeField.delegate = self
        //Setting up colors
        self.view.backgroundColor = UIColor(patternImage: chosenCompanion.shared.companion.bgImage)
        //self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
        addTaskButton.tintColor = chosenCompanion.shared.companion.darkToneColor
        let labels = self.view.subviews.compactMap({$0 as? UILabel?})
        for label in labels {
            label?.textColor = chosenCompanion.shared.companion.darkToneColor
        }
    }
    
    @objc func timePickerValueChange(sender: UIDatePicker) {
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        timeFormater.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timeField.text = timeFormater.string(from: sender.date)
    }
    @objc func timePickerSetDefault(sender: UITextField) {
        if sender.text == "" {
            timeField.text = "12:00"
        }
    }
    @objc func datePickerValueChange(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateField.text = dateFormater.string(from: sender.date)
    }
    @objc func datePickerSetDefault(sender: UITextField) {
        if sender.text == "" {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            dateField.text = dateFormater.string(from: Date())
        }
    }
    @IBAction func AddTaskButtonTapped(_ sender: Any) {
        AddTask()
    }
    func AddTask() {
        //Adding new task
        if taskNameField.text ?? "" != "" {
            if addTaskViewModel.addTask(taskName: taskNameField.text ?? "", taskDescription: descriptionView.text, timeText: timeField.text, dateText: dateField.text, goldAmount: goldField.text, imageNum: iconPicker.selectedSegmentIndex) {
                self.navigationController?.popViewController(animated: false)
                let firstQuestPending = UserDefaults.standard.bool(forKey: "First quest pending")
                if firstQuestPending {
                    AlertView.instance.showAlert(title: "Great! Now you can mark my quest as completed by tapping on a circle!", isSticky: false)
                    UserDefaults.standard.set(false, forKey: "First quest pending")
                } else {
                    AlertView.instance.showAlert(title: "✅ Successfully added task", isSticky: false)
                }
            }
        } else {
            AlertView.instance.showAlert(title: "❌ Please enter task title", isSticky: false)
            taskNameField.becomeFirstResponder()
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
        guard let intText = Int64(textField.text ?? "0") else {
            textField.text = goldValue
            return
        }
        
        if textField.text?.prefix(1)  == "0" && textField.text!.count > 1 {
            textField.text = String(textField.text!.suffix(textField.text!.count - 1))
            goldValue = textField.text!
            return
        }
        if Int64(textField.text!)! > 10000000000 {
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == timeField {
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
        if textField == dateField {
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
