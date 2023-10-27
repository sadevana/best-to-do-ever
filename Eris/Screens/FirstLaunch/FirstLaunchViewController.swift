//
//  FirstLaunchViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/10/2566 BE.
//

import UIKit
import CoreData

class FirstLaunchViewController: UIViewController {
    private var mascotImage: UIImageView = {
        let view = UIImageView()
        let image = chosenCompanion.shared.companion.defaultImage
        view.image = image
        return view
    }()
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var startTime = DispatchTime.now() - 5000000000
    private var coverScreen: UIView = {
        return UIView()
    }()
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var nicknameText: UITextField!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var genderChooseLabel: UILabel!
    @IBOutlet weak var genderPicker: UISegmentedControl!
    
    var nickText = ""
    
    private var currentStage = 0
    private var screenLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup the scene
        mascotImage.frame = CGRect(x: self.view.frame.size.width - 180 - 20, y: self.view.frame.size.height - 230 - 20, width: 250, height: 500)
        containerView.frame = CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.width - 300, width: 300, height: 60)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.containerView.layer.cornerRadius = 20.0
        containerView.backgroundColor = chosenCompanion.shared.companion.primaryColor
        self.view.addSubview(mascotImage)
        
        self.view.backgroundColor = UIColor(patternImage: chosenCompanion.shared.companion.bgImage)
        
        showAlert(title: "Hey and welcome to ENTER APP NAME")
        //showAlert(title: "I'm Luna and I'm gonna be your companion and guide here")
        //showAlert(title: "What is your name?")
        acceptButton.isHidden = true
        nicknameLabel.isHidden = true
        nicknameText.isHidden = true
        skipButton.isHidden = true
        genderChooseLabel.isHidden = true
        genderPicker.isHidden = true
        acceptButton.tintColor = chosenCompanion.shared.companion.darkToneColor
        skipButton.tintColor = chosenCompanion.shared.companion.darkToneColor
        nicknameLabel.textColor = chosenCompanion.shared.companion.darkToneColor
        
        //Setup for validation
        nicknameText.addTarget(self,
                            action: #selector(nameValidation),
                            for: UIControl.Event.editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func showAlert(title: String) {
        //Only showing new alert if previous one is over otherwise check if it's needed later on
        containerView.isUserInteractionEnabled = false
        let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
        if dif > 3000000000 {
            //Show alert and change picture
            //self.mainView.alpha = 1.0
            self.mascotImage.image = chosenCompanion.shared.companion.talkingImage
            screenLocked = true
            self.containerView.isHidden = false
            startTime = DispatchTime.now()
            alertLabel.setTyping(text: title, characterDelay: 4)
            if currentStage != 1 {
                coverScreen.frame = self.view.frame
                self.view.addSubview(coverScreen)
                coverScreen.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverTapped(tapGestureRecognizer:)))
                coverScreen.addGestureRecognizer(tapGestureRecognizer)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
                //In russian it's called 'kostyl'
                if dif > 3000000000 {
                    /*if !isSticky {
                        self.containerView.isHidden = true
                    }*/
                    self.screenLocked = false
                    self.mascotImage.image = chosenCompanion.shared.companion.defaultImage
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showAlert(title: title)
            }
        }
    }
    @objc func coverTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if !screenLocked{
            coverScreen.removeFromSuperview()
            goToNextStage()
        }
    }
    func goToNextStage() {
        switch currentStage {
        case 0:
            showAlert(title: "I'm Luna and I'm gonna be your companion and guide here")
            currentStage = 1
            break
        case 1:
            showAlert(title: "And what shoul I call you?")
            acceptButton.isHidden = false
            nicknameLabel.isHidden = false
            nicknameText.isHidden = false
            skipButton.isHidden = false
            genderChooseLabel.isHidden = false
            genderPicker.isHidden = false
            currentStage = 2
            break
        case 2:
            UserDefaults.standard.set(genderPicker.selectedSegmentIndex, forKey: "GenderIndex")
            if(nicknameText.text != ""){
                showAlert(title: "Nice to meet you, \(nicknameText.text!)!")
                UserDefaults.standard.set(nicknameText.text!, forKey: "Nickname")
            } else {
                showAlert(title: "Alright, keep your secrets!")
            }
            nicknameText.resignFirstResponder()
            acceptButton.isHidden = true
            nicknameLabel.isHidden = true
            nicknameText.isHidden = true
            skipButton.isHidden = true
            genderChooseLabel.isHidden = true
            genderPicker.isHidden = true
            warningLabel.text = ""
            currentStage = 3
        case 3:
            showAlert(title: "Now, let's get right on to creating some quests for you!")
            currentStage = 4
        default:
            //If something broke lets just go to home screen
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeParentViewController")
            self.navigationController!.pushViewController(nextViewController, animated: true)
            UserDefaults.standard.set(true, forKey: "First quest pending")
            if getTasksDB().isEmpty {
                createFirstQuest()
            }
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        goToNextStage()
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeParentViewController")
        self.navigationController!.pushViewController(nextViewController, animated: true)
        //UserDefaults.standard.set(true, forKey: "First quest pending")
    }
    func getTasksDB() -> [TaskUI] {
        //Getting all tasks fro initial setup
        var tasks = [TaskUI]()
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.returnsObjectsAsFaults = false
        let tasksDB = try! CoreDataService().context().fetch(request)
        for taskDBIns in tasksDB {
            tasks.append(TaskUI(taskDB: taskDBIns))
        }
        return tasks
    }
    func createFirstQuest() {
        //Basic task creation
        let context = CoreDataService.shared.context()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let taskAdded = Task(context: context)
        taskAdded.title = "Create your first quest"
        taskAdded.task_description = "Your first quest premade for you by Luna"
        taskAdded.rowid = UUID().uuidString
        taskAdded.gold = 5
        taskAdded.image_number = 1
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    @objc func nameValidation(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 100 {
            textField.text = nickText
            warningLabel.text = "Please enter up to 100 symbols"
            
            return
        } else {
            nickText = textField.text ?? ""
            warningLabel.text = ""
            
        }
    }
}
